# gamergraf
This is my first docker and github project, evolved out of a few things I've found here and there towards doing some really neat monitoring of Windows systems with Grafana, Graphite, CollectD and MSI Afterburner+Remote Server. Its a work in progress for a while, can be run all on one PC or if you are savvy with linux you can run the backend there.  
  
## Dependencies:  Download and install all of this software
The default settings are fine, in the case of the Afterburner Remote Server it does not have an installer, put it somewhere where you can run it.
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
Open afterburner, go to settings, and then go to the monitoring tab. Make sure you have the following things checked for monitoring.
Power, GPU temperature, GPU usage, GPU voltage, Fan speed, Fan tachometer, Core clock, Memory clock, Memory usage, Temp limit, Power limit, Voltage limit, No load limit, Framerate, Frametime, CPU temperature, CPU1 usage, CPU2 usage, CPU3 usage, CPU4 usage, CPU usage, RAM usage.  
If you have more CPU cores be sure to check the CPUX usage for them. You will need to add them to your grafana dashboard CPU charts, which are fairly simple to edit.  
### Step 2:
#### MSI Afterburner Remote Server
Launch the executable, then in the systray right click on it and change the two following settings.
1: HTTP Listener - Set to 809
2: Security - set your password to password
### Step 3:
#### Docker container
