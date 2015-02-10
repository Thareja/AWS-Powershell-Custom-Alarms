<#
.SYNOPSIS
Cloudwatch Script to monitor MYSQL DB
.DESCRIPTION
This is a MYSQL wrapper function to check if we can connect a db successfully and report to AWS Cloudwatch
It will send a 1 if the connection is good and a 0 if the connection was not successful
.NOTES  
    File Name  : check_mysql.ps1  
    Author     : Dhiraj Thareja -   
    Version    : 1.0
    Requires   : PowerShell V2 CTP3  and AWS Tools
.LINK
www.awesomeactually.com
#>

$connectionString = "server=yourserver.cfescolwjzow.us-west-2.rds.amazonaws.com;uid=YourApp;pwd=03dtGOMBNt$k;database=YourDB_production;"
$query= "select top 1 1 from [terraflex_production].[Metrics]"
 
    Begin {
        Write-Verbose "Starting Begin Section"     
    }
    Process {
        Write-Verbose "Starting Process Section"
        try {
            # load MySQL driver and create connection
            Write-Verbose "Create Database Connection"
            # You could also could use a direct Link to the DLL File
            # $mySQLDataDLL = "C:\scripts\mysql\MySQL.Data.dll"
            # [void][system.reflection.Assembly]::LoadFrom($mySQLDataDLL)
            [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
            $connection = New-Object MySql.Data.MySqlClient.MySqlConnection
            $connection.ConnectionString = $ConnectionString
            Write-Verbose "Open Database Connection"
            $connection.Open()
             
            # Run MySQL Querys
            Write-Verbose "Run MySQL Querys"
            $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
            $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
            $dataSet = New-Object System.Data.DataSet
            $recordCount = $dataAdapter.Fill($dataSet, "data")
            $dataSet.Tables["data"] | Format-Table
            
             $dat = New-Object Amazon.CloudWatch.Model.MetricDatum
             $dat.Timestamp = (Get-Date).ToUniversalTime() 
             $dat.MetricName = " MYSQL Connection"
             $dat.Unit = "Count"
             $dat.Value = "1" 
             Write-CWMetricData -Namespace "Usage Metrics" -MetricData $dat
        }       
        catch {
            Write-Host "Could not run MySQL Query" $Error[0]   
             $dat = New-Object Amazon.CloudWatch.Model.MetricDatum
             $dat.Timestamp = (Get-Date).ToUniversalTime() 
             $dat.MetricName = " MYSQL Connection"
             $dat.Unit = "Count"
             $dat.Value = "0" 
             Write-CWMetricData -Namespace "Usage Metrics" -MetricData $dat
            
             
        }   
        Finally {
            Write-Verbose "Close Connection"
            $connection.Close()
        }
    }
    End {
        Write-Verbose "Starting End Section"
    }

