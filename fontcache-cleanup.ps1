#get the Windows Font Cache Service and restart it. Don't try to restart before stopping otherwise it doesn't work well.

$svc = Get-Service fontcache

Stop-Service fontcache

$svc.WaitForStatus('Stopped')

Start-Service fontcache

$svc.WaitForStatus('Running')

#Grab only the user cache files

$fontCacheFiles = Get-ChildItem "C:\Windows\ServiceProfiles\LocalService\AppData\Local\" -Filter "FontCache-S-*.dat"

#delete all the files that can be deleted. Many of the files will be locked if users are still connected, so it's best to skip over them.

foreach ($file in $fontCacheFiles) { 
	try { 
		Remove-Item $file.fullname -Force -ErrorAction silentlyContinue; 
	} 
	catch {
	continue;
	} 
}

#Empty the recycle bin to clear additional space.

$recycleBin = (New-Object -ComObject Shell.Application).NameSpace(0xa)
$recycleBin.items() | foreach { rm $_.path -force -recurse }