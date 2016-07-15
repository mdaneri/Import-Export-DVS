<#  
.SYNOPSIS  Import a VDSwitch configuration  
.DESCRIPTION The function will import the VDSwitch
  configuration(s) from a file. 
  
.PARAMETER Path
  The path to a filename where the config is stored.
.PARAMETER IncludePortgroups
  Switch that indicates if only the VDSwitch configuration
  or the VDSwitch and all portgroups should be exported
 .PARAMETER EntityImportType
  The EntityImportType enum defines the import type for 
  the DistributedVirtualSwitchManager.DVSManagerImportEntity_Task 
  operation. 
.EXAMPLE
  PS> Import-VDSwitch -Path C:\dvswconfig.xml -EntityImportType:applyToEntitySpecified
   
.NOTES
NAME: Import-VDSwitch
AUTHOR: Max Daneri, VMware 
LASTEDIT: 2016/07/15 11:25:00 
KEYWORDS: ESX,ESXi,VMware,vCenter,Backup,Migrate
Version: 1.00
 
.LINK
http://developercenter.vmware.com

#>
 
  param(
    [CmdletBinding()]
    [Parameter(Mandatory=$true)]
    [String]$Path,
    [Switch]$IncludePortgroups = $false,
	[VMware.Vim.EntityImportType]$EntityImportType = [VMware.Vim.EntityImportType]::createEntityWithOriginalIdentifier
	
  )
 
  process {
 
    $si = Get-View ServiceInstance
    $dvSwMgr = Get-View $si.Content.dvSwitchManager
 
    $dvswImport = @()
    Import-Clixml -Path $Path | 
    where{($IncludePortgroups -and $_.EntityType -eq "distributedVirtualPortgroup") -or
        $_.EntityType -eq "distributedVirtualSwitch"} | %{
      $info = New-Object VMware.Vim.EntityBackupConfig
      $info.ConfigBlob = $_.ConfigBlob
      $info.ConfigVersion = $_.ConfigVersion
      $info.Container = $_.Container
      $info.EntityType = $_.EntityType
      $info.Key = $_.Key
      $info.Name = $_.Name
      $dvswImport += $info
    }
    $dvSwMgr.DVSManagerImportEntity($dvswImport,$EntityImportType) | Out-Null
  }
