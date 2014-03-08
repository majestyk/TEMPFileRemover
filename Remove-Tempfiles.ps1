<#
Written by: Tom Johansson
Purpose: This script searches and removes TEMP files from common Windows Directories as well as emptying the Recycling Bin
#>

Write-Host 
"This script will look through and delete TEMPORARY files from the following locations

C:\Windows\Temp
C:\Windows\Prefetch
C:\Users\*\Appdata\Local\Temp
C:\Users\*\Downloads
C:\Users\*\AppData\Roaming\Microsoft\Windows\Cookies\*
C:\Users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*"

# Add folder paths in this line
$tempfolders = @("C:\Windows\Temp\*", "c:\Windows\Prefetch\*", "C:\Users\*\Appdata\Local\Temp\*", "c:\Users\*\Downloads\*", "C:\Users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*", "C:\Users\*\AppData\Roaming\Microsoft\Windows\Cookies\*")

Start-Sleep -Seconds 5
cls

$colItems = (Get-ChildItem $tempfolders -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum)
$sizeoutput = "{0:N2}" -f ($colItems.sum / 1MB) + " MB"
$numberoffiles = (Get-ChildItem $tempfolders -Recurse -Force -ErrorAction SilentlyContinue).count;

Write-Host "Located $numberoffiles files which is $sizeoutput "
Write-Host ""
Write-Host -NoNewline 'Press any key to remove files or CTRL + C to Cancel';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Start-Sleep -Seconds 2
cls

Remove-Item $tempfolders -Force -Recurse -ErrorAction SilentlyContinue -Exclude "C:\Users\AllUsers\AppData\Local\Microsoft\Windows\Temporary Internet Files\*"

for ($i = 1; $i -le 100; $i++) {Write-Progress -Activity 'DELETING FILES' -Status "
$i percent" -PercentComplete $i ; sleep -Milliseconds 20}

Write-Host "Emptying Recycle Bin..."

$Shell = New-Object -ComObject Shell.Application 
$RecBin = $Shell.Namespace(0xA) 
$RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}

for ($i = 1; $i -le 100; $i++) {Write-Progress -Activity 'Taking out the Trash' -Status "
$i percent" -PercentComplete $i ; sleep -Milliseconds 20}

cls
Write-Host ""
Write-Host -NoNewline 'Work has been completed, press any key to finish';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
cls

