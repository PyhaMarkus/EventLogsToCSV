
<#
-----

A PowerShell script for exporting eventlogs of a local machine to a .csv file.

Finds Windows Eventlog error, warning and critical entries for the last 7 days.
Data from those logs is then exported to .csv files in the default directory path C:\Users\Markus\Desktop\SystemLogs\

Markus Pyhäranta. 7.7.2017

-----
#>

#Check whether a folder named SystemLogs exists. If it doesn't, then create one.
$Path = "C:\Users\Markus\Desktop\SystemLogs\"
	If(!(Test-Path $Path)) {
	
		New-Item -ItemType Directory -Force -Path $Path
	
	}
	
#Variables

	#Diretory paths for .csv files.
	$PathError = "C:\Users\Markus\Desktop\SystemLogs\ErrorLogs.csv"
	$PathWarning = "C:\Users\Markus\Desktop\SystemLogs\WarningLogs.csv"
	$PathCritical = "C:\Users\Markus\Desktop\SystemLogs\CriticalLogs.csv"

	#Today's date.
	$Today = Get-Date

	#From how many days are the logs needed. 7 days by default.
	$StartDate = $Today.AddDays(-7)

#Notify user that the process is in progress.

Write-Host "Exporting systemlogs to .csv`n..."


#ErrorLogs
	#Get the newest 100 error entries of the system's eventlogs and export results to a .csv file.	
	Get-EventLog -LogName System -ComputerName Make-PC -Newest 100 -After $StartDate -EntryType Error |
	Select-Object EventID, TimeGenerated, EntryType, Source, Message |
	Export-Csv -NoTypeInformation $PathError -Delimiter ";" -Encoding UTF8

#WarningLogs
	#Get the newest 100 warning entries of the system's eventlogs and export results to a .csv file.	
	Get-EventLog -LogName System -ComputerName Make-PC -Newest 100 -After $StartDate -EntryType Warning |
	Select-Object EventID, TimeGenerated, EntryType, Source, Message |
	Export-Csv $PathWarning -Delimiter ";" -Encoding UTF8

#CriticalLogs
	#Get the newest 100 critical entries of the system's eventlogs and export results to a .csv file.
	#Note: Level=1; = Critical, Level=2; = Error, Level=3; = Warning
	Get-WinEvent -FilterHashtable @{LogName="System"; Level=1; StartTime=$StartDate;} -MaxEvents 100 |
	Select-Object Id, TimeCreated, ProviderName, LevelDisplayName, Message |
	Export-Csv -NoTypeInformation $PathCritical -Delimiter ";" -Encoding UTF8
	
	
#Notify user that the process is done.
Write-Host 'All done!'


<#
-----
Script ends here.
-----
#>