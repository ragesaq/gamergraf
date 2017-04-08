# gamergraf
This is my first docker and github project, evolved out of a few things I've found here and there towards doing some really neat monitoring of Windows systems with Grafana, Graphite, CollectD and MSI Afterburner+Remote Server. The backend is pretty polished at this point, you shouldn't have to do anything other than docker-compose up.
  
## Dependencies:  Download and install all of this software
The default settings are fine, in the case of the Afterburner Remote Server it does not have an installer, put it in a folder somewhere where you can find and run it.
### Backend Software
#### Docker - If you are running windows be sure you first install Docker for Windows which you can get from here - https://download.docker.com/win/stable/InstallDocker.msi
  
###  Instrumentation software
Install these on the PC you want to monitor

#### MSI Afterburner
You need to run this for the monitoring services provided - http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip

#### MSI Afterburner Remote Server
Provides a simple web service that exposes the Afterburner monitored data for collectd to grab - http://download.msi.com/uti_exe/vga/MSIAfterburnerRemoteServer.zip

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
4.1: From a command-line in the folder containing the gamergraf project run docker-compose build  
4.2: From a command-line in the folder containing the gamergraf project run docker-compose up -d  
### Step 5:
#### Log into the grafana page
5.1: Open a web browser and navigate to http://<ip address of system running docker>:3000. If you ran this on your local PC you can load it up with http://localhost:3000  
5.2: Login with the username 'admin' and the password you entered in 3.5  
5.3: Enjoy!  
  
Note: If you have more than 4 cores you will want to select 'edit' under the CPU Utilization Detail graph, duplicate one of the CPU queries, change the query to target CPU5 or CPU6 etc, and then change the alias name to reflect that CPU. Once you complete that click back to dashboard at the top, and then click save.  
