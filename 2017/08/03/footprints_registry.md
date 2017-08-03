---
layout: page
---

Below is a copy of `footprints_registry.pp` which shows how you can manage all
the restistry keys that are needed by many applications. You can download the
raw file [here]({{ site.url }}/2017/08/03/footprints_registry.pp)

```puppet
registry_value { 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\DeleteTempDirsOnExit':
  ensure => present,
  type   => 'dword',
  data   => '0',
}

registry_value { 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\PerSessionTempDir':
  ensure => present,
  type   => 'dword',
  data   => '0',
}

registry_value { 'HKLM\SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\Tomcat7\Parameters\Java\JvmMs':
  ensure  => present,
  type    => 'dword',
  data    => '12288',
  require => Package['jre8'],
  notify  => Service['tomcat7'],
}
registry_value { 'HKLM\SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\Tomcat7\Parameters\Java\JvmMx':
  ensure  => present,
  type    => 'dword',
  data    => '14336',
  require => Package['jre8'],
  notify  => Service['tomcat7'],
}

registry_value { 'HKLM\SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\Tomcat7\Parameters\Java\Options':
  ensure  => present,
  type    => 'array',
  data    => ['-Dcatalina.home=C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-7.0.69',
    '-Dcatalina.base=C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-7.0.69',
    '-Djava.endorsed.dirs=C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-7.0.69\endorsed',
    '-Djava.io.tmpdir=C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-7.0.69\temp',
    '-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager',
    '-Djava.util.logging.config.file=C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-7.0.69\conf\logging.properties',
    '-Dfile.encoding=UTF-8',
  ],
  require => Package['jre8'],
  notify  => Service['tomcat7'],
}

```
