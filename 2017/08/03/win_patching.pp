$maintenance_day  = lookup('windows::maintenance_day', { 'default_value' => 'Saturday'})

schedule { 'Maintenance Window':
  range   => '1:30 - 4:30',
  weekday => $maintenance_day,
}

# This just defines a reboot resource, it doesn't reboot the system
reboot { 'before':
  when     => pending,
  schedule => 'Maintenance Window',
}

# Do not try and manage these same settings in a GPO as the two will conflict
# Adjust these to match your environment.
class { '::wsus_client' :
  no_auto_update                      => true,
  auto_update_option                  => 'NotifyOnly',
  detection_frequency_hours           => 1,
  no_auto_reboot_with_logged_on_users => false,
  server_url                          => 'http://wsus.example.com',
  # target_group                        => 'ServerUpdates',
  purge_values                        => true,
  before                              => Exec['Run Windows Update'],
}

# Bootstraps chocolatey
class { '::chocolatey':
  log_output => true,
  schedule   => 'Maintenance Window',
}

# Makes packages installed via chocolatey show up in Programs and Features
chocolateyfeature { 'autouninstaller':
  ensure   => enabled,
  schedule => 'Maintenance Window',
}

# Keep chocolatey updated
package { 'chocolatey':
  ensure   => latest,
  provider => 'chocolatey',
  schedule => 'Maintenance Window',
}

# Install the latest version of PowerShell
# This is needed for the execs below to work correctly
package { 'powershell':
  ensure   => latest,
  provider => 'chocolatey',
  schedule => 'Maintenance Window',
}

exec { 'Install NuGet package provider':
  command   => '$(Install-PackageProvider -Name NuGet -Force)',
  onlyif    => '$(if((Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue) -eq $null) { exit 0 } else { exit 1 })',
  provider  => 'powershell',
  logoutput => true,
  require   => Package['powershell'],
  schedule  => 'Maintenance Window',
}

exec { 'Install PSWindowsUpdate module':
  command   => '$(Install-Module -Name PSWindowsUpdate -Scope AllUsers -Force)',
  onlyif    => '$(if((Get-Module PSWindowsUpdate -list) -eq $null) { exit 0 } else { exit 1 })',
  provider  => 'powershell',
  logoutput => true,
  require   => Exec['Install NuGet package provider'],
  schedule  => 'Maintenance Window',
}

exec { 'Run Windows Update':
  command   => '$(Get-WUInstall -IgnoreUserInput -ShowSearchCriteria -AcceptAll -IgnoreReboot -Verbose)',
  onlyif    => '$(if (@(Get-WUInstall -IgnoreUserInput -ListOnly).Count -gt 0) { exit 0 } else { exit 1 })',
  provider  => 'powershell',
  logoutput => true,
  require   => Exec['Install PSWindowsUpdate module'],
  schedule  => 'Maintenance Window',
}
