<#  
.SYNOPSIS  Export a dvSwitch configuration  
.DESCRIPTION The function will export the dvSwitch
  configuration(s) to a file. 
  This requires at least vSphere 5.1.

.PARAMETER dvSw
  The dvSwitch(es) whose config you want to export.
.PARAMETER Path
  The path to a filename where the config should be
  written to.
.PARAMETER IncludePortgroups
  Switch that indicates if only the dvSwitch configuration
  or the dvSwitch and all portgroups should be exported
.EXAMPLE
  PS> Export-dvSwConfig -Name DSwitch01 -Path C:\dvswconfig.xml -IncludePortgroups
.EXAMPLE
  PS> $dvSw = Get-VDSwitch -Name DSwitch01
  PS> $dvsw | Export-dvSwConfig -Path C:\dvswconfig.xml
  
.NOTES
NAME: Export-VDSwitch
AUTHOR: Max Daneri, VMware 
LASTEDIT: 2016/07/15 11:25:00 
KEYWORDS: ESX,ESXi,VMware,vCenter,Backup,Migrate
Version: 1.00
 
.LINK
http://developercenter.vmware.com

#>
 
  param(
    [CmdletBinding()]
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [PSObject]$dvSw,
    [String]$Path,
    [Switch]$IncludePortgroups = $false
  )
 
  begin {
    $si = Get-View ServiceInstance
    $dvSwMgr = Get-View $si.Content.dvSwitchManager
    $selectionTab = @()
  }
 
  process{
    if($dvSw -is [System.String]){
      $dvSw = Get-VDSwitch -Name $dvsw
    }
    if($IncludePortgroups){
      $selection = New-Object VMware.Vim.DVPortgroupSelection
      $selection.portgroupKey = Get-VDPortGroup -VDSwitch $dvsw | %{$_.Key}
      $selection.dvsUuid = $dvsw.ExtensionData.Uuid
      $selectionTab += $selection
    }
    $selection = New-Object VMware.Vim.DVSSelection
    $selection.dvsUuid = $dvsw.ExtensionData.Uuid
    $selectionTab += $selection
	$selectionTab
  }
 
  end{
    $dvswSaved = $dvSwMgr.DVSManagerExportEntity($selectionTab)
    $dvswSaved | Export-Clixml -Path $Path
  }
 



