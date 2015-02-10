<#
.SYNOPSIS
Custom Cloudwatch Script to monitor Websites
.DESCRIPTION
This is a webpage load wrapper function to check if we can load a webpage successfully and report to AWS Cloudwatch
.NOTES  
    File Name  : check_webpage.ps1  
    Requires   : PowerShell V2 CTP3  & Installed AWS Tools
    Description: Install as scheduled task the following command C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -Command "Import-Module 'C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1'; Initialize-AWSDefaults -AccessKey ********* -SecretKey ************* -Region us-west-2; . C:\[location]\cloudwatch_check_webpage1.ps1" 

#>


$webClient = new-object System.Net.WebClient
$webClient.Headers.Add("user-agent", "PowerShell Script")


   $output = ""



   Try {
            $startTime = get-date
   $output = $webClient.DownloadString("http://www.yahoo.com")
   $endTime = get-date
   
     if ($output -like "*Yahoo*") {
      

$dat = New-Object Amazon.CloudWatch.Model.MetricDatum
$dat.Timestamp = (Get-Date).ToUniversalTime() 
$dat.MetricName = "Yahoo Website"
$dat.Unit = "Count"
$dat.Value = ($endTime - $startTime).TotalSeconds 
Write-CWMetricData -Namespace "Usage Metrics" -MetricData $dat

   } else {
   
   
   

$dat = New-Object Amazon.CloudWatch.Model.MetricDatum
$dat.Timestamp = (Get-Date).ToUniversalTime() 
$dat.MetricName = "Yahoo Website"
$dat.Unit = "Count"
$dat.Value = "99" 
Write-CWMetricData -Namespace "Usage Metrics" -MetricData $dat

   }
   
            }
        Catch {
     

$dat = New-Object Amazon.CloudWatch.Model.MetricDatum
$dat.Timestamp = (Get-Date).ToUniversalTime() 
$dat.MetricName = "Yahoo Website"
$dat.Unit = "Count"
$dat.Value = "99" 
Write-CWMetricData -Namespace "Usage Metrics" -MetricData $dat
     
            }
