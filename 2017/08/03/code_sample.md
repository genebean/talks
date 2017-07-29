---
layout: page
---

Below is a copy of `win_patching.pp` which demonstrates a method
for patching Windows systems within a change window. This code was used as demo
during my presentation. You can download the raw file [here]({{ site.url }}/2017/08/03/win_patching.pp)

```puppet
class { 'chocolatey':
  log_output => true,
}

chocolateyfeature { 'autouninstaller':
  ensure => enabled,
}

exec { 'Install NuGet package provider':
  command   => '$(Install-PackageProvider -Name NuGet -Force)',
  onlyif    => '$(if((Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue) -eq $null) { exit 0 } else { exit 1 })',
  provider  => powershell,
  logoutput => true,
}

exec { 'Install PSWindowsUpdate module':
  command   => '$(Install-Module -Name PSWindowsUpdate -Scope AllUsers -Force)',
  onlyif    => '$(if((Get-Module PSWindowsUpdate -list) -eq $null) { exit 0 } else { exit 1 })',
  provider  => powershell,
  logoutput => true,
  require   => Exec['Install NuGet package provider'],
}

$maintenance_day  = lookup('windows::maintenance_day', { 'default_value' => 'Saturday'})

schedule { 'Maintenance Window':
  range   => '1:30 - 4:30',
  weekday => $maintenance_day,
}

reboot { 'before':
  when     => pending,
  schedule => 'Maintenance Window',
}

package { 'powershell':
  ensure   => latest,
  provider => 'chocolatey',
  schedule => 'Maintenance Window',
}

exec { 'Run Windows Update':
  command   => '$(Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -ShowSearchCriteria -AcceptAll -IgnoreReboot -Verbose)',
  onlyif    => '$(if (@(Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -ListOnly).Count -gt 0) { exit 0 } else { exit 1 })',
  provider  => powershell,
  logoutput => true,
  schedule  => 'Maintenance Window',
  require   => Exec['Install PSWindowsUpdate module'],
}

# Do not try and manage these same settings in a GPO as the two will conflict
class { 'wsus_client' :
  no_auto_update                      => true,
  auto_update_option                  => 'NotifyOnly',
  detection_frequency_hours           => 1,
  no_auto_reboot_with_logged_on_users => false,
  server_url                          => 'http://wsus.example.com',
  #target_group                        => 'ServerUpdates',
  purge_values                        => true,
  before                              => Exec['Run Windows Update'],
}
```
