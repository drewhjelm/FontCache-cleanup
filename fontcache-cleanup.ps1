#get the Windows Font Cache Service and restart it. Don't try to restart before stopping otherwise it doesn't work well.

$svc = Get-Service fontcache

Stop-Service fontcache

$svc.WaitForStatus('Stopped')

Start-Service fontcache

$svc.WaitForStatus('Running')

#Grab only the user cache files

$fontCacheFiles = Get-ChildItem "C:\Windows\ServiceProfiles\LocalService\AppData\Local\" -Filter "FontCache-S-*.dat"

#delete all the files that can be deleted. Many of the files will be locked if users are still connected, so it's best to skip over them.

$totalFileSizeDeleted = 0
$totalFilesDeleted = 0
$totalErrorFiles = 0

foreach ($file in $fontCacheFiles) { 
	try { 
		$ErrorActionPreference = "Stop";
		$fileSize = $file.length
		Remove-Item $file.fullname -Force; 
		$totalFileSizeDeleted += $fileSize;
		$totalFilesDeleted++;
	} 
	catch {
		Write-Output "Error deleting $file because it is in use by another process."
		$totalErrorFiles++;
	} 
	finally {
		$ErrorActionPreference = "Continue"; 
	}
}

#Empty the recycle bin to clear additional space.

$recycleBin = (New-Object -ComObject Shell.Application).NameSpace(0xa)
$recycleBin.items() | foreach { rm $_.path -force -recurse }

Write-Output "Total Files Deleted: $totalFilesDeleted. Total Space Freed: $totalFileSizeDeleted. Total Files Not Deleted: $totalErrorFiles."