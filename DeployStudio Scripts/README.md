
These are the scripts we use with DeployStudio for lab computer deployment.

- **ConfigureMunkiClients.pl**: This script will configure the client computers to connect so they can connect to the Munki server. The script needs to run as a post-imaging, after the computer has rebooted off it's internal drive. The script will also set the Apple Software Updates to the production branch of our update server. Munki will later change the settings based on various paramaters.


- **SetTimeZone.sh**: This script will properly set the time zone and time server on the client computer. We found that the workflow in DS didn't seem to work. Added some other settings for the administrtor account for the TLL labs. The script needs to run as a post-imaging, after the computer has rebooted off it's internal drive.


- **SINC\_AddAccount.sh**: Add secondary domain account as admins on the local computers. The script needs to run as a post-imaging, after the computer has rebooted off it's internal drive.


- **SINC\_disable\_munki\_check.sh**: Disable the hourly upfate check from Munki. On lab computers we want it to only run when we want it to run (at night) as to reduce disruption. The script needs to run as a post-imaging, after the computer has rebooted off it's internal drive.
  
  
- **SINC\_Disable\_SIP.sh**: Disables SIP. We still have software that doesn't play nice, and wants to install in the protected locations. Hopefully this will change at a later date. The script needs to run while the computer is a netboot state, after the computer has rebooted off it's internal drive.


- **SINC\_Enable\_ARD.sh**: Enables ARD right after imaging, thus allowing admins to gain remote access while the computers install software, profiles, settings etc. The script needs to run while the computer is a netboot state, after the computer has rebooted off it's internal drive.


- **SINC\_Enable\_SSH.sh**: Enables SSH right after imaging, thus allowing admins to gain remote access while the computers install software, profiles, settings etc. The script needs to run while the computer is a netboot state, after the computer has rebooted off it's internal drive.


- SINC\_Fix\_Names.sh: For a while DeployStudio wasn't properly setting the hostname, thus a script to remedy. The script needs to run while the computer is a netboot state, after the computer has rebooted off it's internal drive.


- **SINC\_Setup\_MunkiReport\_PHP.sh**: Configures MunkiReport on the clients so they can report back. The script needs to run while the computer is a netboot state, after the computer has rebooted off it's internal drive.


- **TLL\_AddAccount.sh**: Adds specific Active Directory users and groups to the local admin group. The script needs to run while the computer is a netboot state, after the computer has rebooted off it's internal drive.
