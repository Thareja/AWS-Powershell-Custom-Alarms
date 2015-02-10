<#
.SYNOPSIS
Cloudwatch Script to monitor Website
.DESCRIPTION
This is a webpage load wrapper function to check if we can load a webpage successfully and report to AWS Cloudwatch
.NOTES  
    File Name  : check_mysql.ps1  
    Author     : Dhiraj Thareja  
    Version    : 1.0
    Requires   : PowerShell V2 CTP3  & Installed AWS Tools
    Description: Install as scheduled task the following command C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -Command "Import-Module 'C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1'; Initialize-AWSDefaults -AccessKey your_accesskey -SecretKey your_secretkey -Region us-west-2; . C:\Users\dtharej\Documents\cloudwatch_check_webpage1.ps1" 
.LINK
www.yahoo.com
#>


$webClient = new-object System.Net.WebClient
$webClient.Headers.Add("user-agent", "PowerShell Script")


   $output = ""


 
   Try {
            $startTime = get-date
   $output = $webClient.DownloadString("https://yahoo.com")
   $endTime = get-date
   
     if ($output -like "*Terms*") {
      
 
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

 

 
