# gamergraf 
![https://snapshot.raintank.io/dashboard/snapshot/2t5C4T4wE77QIQHO1QmFc2dfXRj1zBlm](http://i.imgur.com/k14gj8B.png "gamergraf dashboard")

This is my first docker and github project, evolved out of a few things I've found here and there towards doing some really neat monitoring of Windows systems with Grafana, Graphite, CollectD and MSI Afterburner+Remote Server. Its customizable and easily expandable, and best of all, portable thanks to docker!  
There are some other nice software packages out there that can do similar things, but Afterburner seems to be the best so far, if you know of a good instrumentation application that can get CPU/GPU/FPS stats and serve it up accurately at 1s resolution I would love to hear about it!
  
The backend is pretty polished at this point, you shouldn't have to do anything other than docker-compose up be it on windows or a remote linux box. You can see an exported interactive snapshot of gamergraf (a feature of grafana) here: https://snapshot.raintank.io/dashboard/snapshot/2t5C4T4wE77QIQHO1QmFc2dfXRj1zBlm  
  
Note mostly for VR users: You must maintain focus of the game application window if you want Afterburner to log the fps/frametime data. 
  
Credit to ycnz for hooking me up with the collectd curl_xml plugin settings that took my project to the next level!  
  
## Dependencies:  Download and install all of this software
The software pieces that make up this solution are divded up into two different functions, the backend and the instrumentation. The backend can be installed on the same system the instrumentation is installed on, but it can also be installed on another system on the network provided it has a solid network connection. With the rate of polling collectd is configured for I am not sure how well a wireless network connection would stand up.  
The instrumentation software has to run on the computer you want monitored, and some of the components might be something you use already.  
  
### Backend Software
#### Docker 
I have developed and tested this docker container on both CentOS 7.3 and Windows 10 using the new Docker for Windows that leverages the advanced Hyper-V functionality, I am not sure if the legacy Windows Docker applications would work without modifications. It will likely work on all linux operating systems that meet the modern docker release requirements, and will probably also work on Mac OSX.  
Docker Compose is also required.  
  
Docker for Windows 10, which includes Docker Compose - https://download.docker.com/win/stable/InstallDocker.msi  
*Note you need to be sure to configure Docker for Windows to share whatever drive you want to run the grafana package from, and some Antivirus applications process and/or network protection can cause some issues enabling this.
Docker for Linux installation instructions - https://docs.docker.com/engine/getstarted/step_one/#step-2-install-docker  
Docker Compose for linux - https://github.com/docker/compose/releases  
Gamergraf docker container - https://github.com/ragesaq/gamergraf/archive/master.zip

For those who don't know what Docker is, docker is a platform for packaging together software packages and running them in their own containers. Its a little bit like running a virtual machine but its really focused around tight packaged and preconfigured applications. It allows for applications like this to run on any operating system that can run docker and is extremely simple to install and run.  
Docker Compose is a small utility that enhances some functions of docker by providing a simple config file that can be used to easily define how the container runs.  
The docker container running the backend can run on any system that has a solid network connection to the system you want to monitor.  
  
The docker container that runs the backend consists of [Grafana](http://www.grafana.com) for dashboarding/visualization, [Graphite](https://graphiteapp.org/) for storing metrics and [Collectd](https://collectd.org/) for retrieving metrics from the servers defined for monitoring. The container has them all preconfigured and all of the settings prepopulated.  
  
###  Instrumentation software
#### MSI Afterburner
You need to run this for the monitoring services provided - http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip  
*Note: If you have a 10xx series card I would recommend at least Afterburner v4.4 beta 9 - http://office.guru3d.com/afterburner/MSIAfterburnerSetup440Beta9.rar
*Note 2: If you don't have an MSI card you might want to check this thread for a custom voltage control mapping file - http://www.overclock.net/t/1625653/how-to-get-voltage-slider-in-afterburner-working-on-a-1080-ti

  
#### MSI Afterburner Remote Server
Provides a simple web service that exposes the Afterburner monitored data for collectd to grab - http://download.msi.com/uti_exe/vga/MSIAfterburnerRemoteServer.zip
  
I've used several different software components over time for getting good instrumentation from Windows, like Open Hardware Monitor, but none of them have an FPS/Frametime monitor. I would love to hear about any other suggestions for instrumentation, especially if it serves up XML for easier retrieval from Collectd.  
  
## Installation
### Step 1: 
#### MSI Afterburner
1.1: Install MSI Afterburner. During the installation process it will ask you to install RTSS (RivaTuner Statistics Server), which you need to capture frametime/framerate, so be sure to install this too.
1.2: Open afterburner, go to settings, and then go to the monitoring tab. Make sure you have the following things checked for monitoring:  
1.3: Power, GPU temperature, GPU usage, GPU voltage, Fan speed, Fan tachometer, Core clock, Memory clock, Memory usage, Temp limit, Power limit, Voltage limit, No load limit, Framerate, Frametime, CPU temperature, CPU1 usage, CPU2 usage, CPU3 usage, CPU4 usage, CPU usage, RAM usage, Pagefile usage.  
If you have more CPU cores be sure to check the CPUX usage for them. You will need to add them to your grafana dashboard CPU charts, which are fairly simple to edit.    
### Step 2:
#### MSI Afterburner Remote Server
Launch the executable, then in the systray right click on it and change the two following settings.  
##### Optional Afterburner port and password settings
Change the Afterburner remote settings  
2.1: HTTP Listener - Default is 82, change this if you would like to use a different port, be sure to update this in step 3.3  
2.2: Security - Default is 17cc95b4017d496f82, change this if you would like to use a different password, be sure to update step 3.4  
2.3: Restart MSI Afterburner Remote Server  
### Step 3:
#### Docker container download and config
3.1a: For Windows, download the project from here https://github.com/ragesaq/gamergraf/archive/master.zip, extract it to a folder of your choice and then use notepad or other file editor to edit the docker-compose.yml file and fill out the settings below. Note that yml files are fairly format sensitive to things like spacing (extra/fewer spaces), carriage returns, etc so try to preserve the file structure.  
3.1b: For Linux, download the project or 'git clone https://github.com/ragesaq/gamergraf.git' and then edit the docker-compose.yml file and fill out the settings below.  
  
*Note* I have some reports of issues using git on windows to clone the project and the container not building/working correctly. It is probably some linux/windows git file conversion issues/settings. Downloading the zip from this page and extracting it resolved that issue. I'm not sure what the problem is related to and I am looking into it.
3.2: HOST_IP - Enter the IP address of the PC you want to monitor  
3.3: HOST - enter the hostname of the PC you want to monitor  
3.4: HOST_PORT - (Optional) Change this if you changed the port in Step 2.1. By default it is 82  
3.5: AFTERBURNER_PASSWORD - (Optional) Change this if you changed the password in Step 2.2. By default it is 17cc95b4017d496f82  
### Step 4:
#### Running the docker container
4.1: Simplified Windows batch files: Run the gamergraf-start batch file in the gamergraf folder. This runs the command 'docker-compose build' which downloads and sets up all of the docker containers and then runs the command 'docker-compose up -d' which launches the containers. The build process can be a little lengthy if this is the first run.  
  
*Optional*  
  
4.2: For command line control under Windows or Linux first run the build command from the folder the containerwas extracted to by running 'docker-compose build', and then run 'docker-compose up -d' to launch the containers.  
### Step 5:
#### Log into the grafana page
5.1: Open a web browser and navigate to http://<ip address of system running docker>:3000. If you ran this on your local PC you can load it up with http://localhost:3000  
5.2: Log in with the username 'admin' and the password 'password'. You can change the password by clicking on the grafana logo in the top left, going to Admin and then going to Profile.  
5.3: Enjoy!  
  
The container services should automatically launch on reboot, so as long as you want to run this software you don't have to do anything.  
  
If you want to prevent the software from running automatically you should run the 'gamergraf-uninstall' batch file, which will run the 'docker-compose down' command. This will stop the container and then remove them from your system. The data for the database is still retained in the gamergraf folder, so you can run the gamergraf-start script again and resume monitoring with the data you already collected.  
  
There are a few other batch scripts to run some docker commands in the gamergraf folder that are fairly self explanitory, I'll give them a more proepr writeup later.  
  
## Removal
Follow these steps to remove the components. To reinstall them just start from the installation at the top.  
  
### Docker Backend  
1.1: Run the 'gamergraf-uninstall' batch script in the gamergraf folder, this will run the 'docker-compose down' script which stops the service and removes the containers.  
1.2: Delete the folder the gamegraf project is stored in, this will delete the databases and all files related to the project.  
1.3: Uninstall docker from your PC  
  
### Instrumentation
2.1: Uninstall MSI Afterburner Remote Server  
2.2: Unisntall MSI Afterburner  
