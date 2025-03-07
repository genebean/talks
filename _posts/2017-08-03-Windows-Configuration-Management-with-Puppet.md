---
layout: post
title: Windows Configuration Management with Puppet
subtitle: Presented at ConfigMgmtCamp PDX 2017
tags: [windows, puppet]
---

_Abstract:_ Do you ever find that GPO's are not enough to get things setup the way you would
like? Tried DSC but found that it too doesn't quite do what you need? Tired of
using scripts to fill this gap? Maybe you've heard all the buzz over the last
several years around configuration management on Linux and wished some of that
goodness was available for Windows? Well, it turns out that you're in
luck! These scenarios are just the kind of thing Puppet can help you with.

Here are some of the topics we will touch on in this talk:

* Combining Desired State Config (DSC) with Puppet for maximum flexibility
* Chocolaty, or as I describe it to people, apt-get / yum for Windows
* WSUS + strict change windows + Puppet = hands-off patching
* PowerShell everywhere... not just on Windows
* Log shipping and monitoring agent setup
* Creating custom facts via WMI
* Configuring Hyper-V
* SCCM integration
* IIS

As a bonus, I'll also talk about how you can take advantage of some open source
work to build Windows VM templates.

## Bug Notice

While running the code below I found what I believe is a bug. That bug has been
reported in ticket [MODULES-5395](https://tickets.puppetlabs.com/browse/MODULES-5395).
Please take note of that before using the sample in production.

## Presentation

* [Code sample]({{ site.url }}/2017/08/03/code_sample)
* [Footprints registry example]({{ site.url }}/2017/08/03/footprints_registry)
* [PDF]({{ site.url }}/2017/08/03/Windows-Configuration-Management-with-Puppet.pdf)
* [PowerPoint]({{ site.url }}/2017/08/03/Windows-Configuration-Management-with-Puppet.pptx)

## Resources

* [CodeSample-win_patching.mp4]({{ site.url }}/2017/08/03/CodeSample-win_patching.mp4)
* [dsc-vs-puppet.png]({{ site.url }}/2017/08/03/dsc-vs-puppet.png)
* [package-dsc-vs-puppet.png]({{ site.url }}/2017/08/03/package-dsc-vs-puppet.png)
