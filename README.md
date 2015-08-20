# FontCache-cleanup
A script to clean up the fontcache on Windows

Terminal servers can accumulate a significant number of fontcache files over a period of time as new users log on to them. These files are not automatically deleted by Windows. 

https://social.technet.microsoft.com/Forums/office/en-US/3795364f-b66c-43ae-82d3-8ed5eb1aa2ce/local-service-system-profile-grown-to-extremely-large-size?forum=winserverTS

In future versions of Windows, Microsoft has promised to look into this, but in the near future, there are two options to limit this folder growing to out of control proportions:

1. Disable the Font Cache service. This may or may not have a negligible performance impact on users, but it is an option to keep the folder size small.
2. Clear the Font Cache files on a regular interval. Clearing out the files will help maintain disk space.

This Powershell script was designed to run as a Windows Scheduled Task
