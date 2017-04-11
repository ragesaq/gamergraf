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
Docker for Linux installation instructions - https://docs.docker.com/engine/getstarted/step_one/#step-2-install-docker  
Docker Compose for linux - https://github.com/docker/compose/releases  
  
For those who don't know what Docker is, docker is a platform for packaging together software packages and running them in their own containers. Its a little bit like running a virtual machine but its really focused around tight packaged and preconfigured applications. It allows for applications like this to run on any operating system that can run docker and is extremely simple to install and run.  
Docker Compose is a small utility that enhances some functions of docker by providing a simple config file that can be used to easily define how the container runs.  
The docker container running the backend can run on any system that has a solid network connection to the system you want to monitor.  
  
The docker container that runs the backend consists of [Grafana](http://www.grafana.com) for dashboarding/visualization, [Graphite](https://graphiteapp.org/) for storing metrics and [Collectd](https://collectd.org/) for retrieving metrics from the servers defined for monitoring. The container has them all preconfigured and all of the settings prepopulated.  
  
###  Instrumentation software
#### MSI Afterburner
You need to run this for the monitoring services provided - http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip
  
#### MSI Afterburner Remote Server
Provides a simple web service that exposes the Afterburner monitored data for collectd to grab - http://download.msi.com/uti_exe/vga/MSIAfterburnerRemoteServer.zip
  
I've used several different software components over time for getting good instrumentation from Windows, like Open Hardware Monitor, but none of them have an FPS/Frametime monitor. I would love to hear about any other suggestions for instrumentation, especially if it serves up XML for easier retrieval from Collectd.  
  
## Installation
### Step 1: 
#### MSI Afterburner
1.1: Open afterburner, go to settings, and then go to the monitoring tab. Make sure you have the following things checked for monitoring:  
1.2: Power, GPU temperature, GPU usage, GPU voltage, Fan speed, Fan tachometer, Core clock, Memory clock, Memory usage, Temp limit, Power limit, Voltage limit, No load limit, Framerate, Frametime, CPU temperature, CPU1 usage, CPU2 usage, CPU3 usage, CPU4 usage, CPU usage, RAM usage.  
If you have more CPU cores be sure to check the CPUX usage for them. You will need to add them to your grafana dashboard CPU charts, which are fairly simple to edit.    
### Step 2:
#### MSI Afterburner Remote Server
Launch the executable, then in the systray right click on it and change the two following settings.  
2.1: HTTP Listener - Set to 8098 or a port of your choice  
2.2: Security - set your password to a password of your choosing  
2.3: Restart MSI Afterburner Remote Server  
### Step 3:
#### Docker container download and config
Clone/download this project to your desired location, and then edit the docker-compose.yml file and change the five environment variables.  
3.1: HOST_IP - Enter the IP address of the PC you want to monitor  
3.2: HOST_PORT - Enter the port you entered in Step 2.1  
3.3: HOST - enter the hostname or any name you would like  
3.4: AFTERBURNER_PASSWORD - Enter the password you defined in Step 2.2  
3.5: GF_SECURITY_ADMIN_PASSWORD - Enter the password for grafana to a password of your choosing  
### Step 4:
#### Running the docker container
4.1: From a command-line in the folder containing the gamergraf project run the command "docker-compose build", this can take a few minutes during which the containers are installed and configured.  
4.2: From a command-line in the folder containing the gamergraf project run the command "docker-compose up -d", this will start the containers and only takes a second or two.  
### Step 5:
#### Log into the grafana page
5.1: Open a web browser and navigate to http://<ip address of system running docker>:3000. If you ran this on your local PC you can load it up with http://localhost:3000  
5.2: Login with the username 'admin' and the password you entered in 3.5  
5.3: Enjoy!  
  
Note: If you have more than 4 cores you will want to select 'edit' under the CPU Utilization Detail graph, duplicate one of the CPU queries, change the query to target CPU5 or CPU6 etc, and then change the alias name to reflect that CPU. Once you complete that click back to dashboard at the top, and then click save.  
  
## Removal
Follow these steps to remove the components. To reinstall them just start from the installation at the top.  
### Docker Backend  
1.1: From a command-line in the folder containing the gamergraf project run the command "docker-compose down". This stops the containers and removes their container images from the docker engine. The data stored in the database and any customizations you have made to grafana is not removed.  
1.2: Delete the folder the gamegraf project is stored in, this will delete the databases and all files related to the project.  
1.3: Uninstall docker  
### Instrumentation
2.1: Uninstall MSI Afterburner Remote Server  
2.2: Unisntall MSI Afterburner  
