$svc = Get-Service fontcache

net stop fontcache 

$svc.WaitForStatus('Stopped','00:00:15')

net start fontcache

$svc.WaitForStatus('Running','00:00:15')

$fontCacheFiles = Get-ChildItem "C:\Windows\ServiceProfiles\LocalService\AppData\Local\" -Filter "FontCache-S-*.dat"

foreach ($file in $fontCacheFiles) { 
	try { 
		Remove-Item $file.fullname -Force -ErrorAction silentlyContinue; 
	} 
	catch {
	continue;
	} 
}

$recycleBin = (New-Object -ComObject Shell.Application).NameSpace(0xa)
$recycleBin.items() | foreach { rm $_.path -force -recurse }