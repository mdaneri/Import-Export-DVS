# Import-Export-VDSwitch
CmdLet to import/export a VMware vSphere Distributed Virtual Switch Configuration 
Usage 
  Export:
      PS> Connect-VIServer vcenter01
      PS> $dvSw = Get-VDSwitch -Name DSwitch01
      PS> $dvsw | Export-VDSwitch -Path C:\dvswconfig.xml

  Import:
      PS> Connect-VIServer vcenter02 
      PS> Import-VDSwitch -Path C:\dvswconfig.xml -EntityImportType:applyToEntitySpecified
      
      
