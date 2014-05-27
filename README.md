# Puppet hiera-based roles

There are a lot of approaches on abstraction layers towards puppet, often called roles or profiles. Most of these boil down to creating manifests (.pp-file) of *classes*. At Bitbrains we didn't think this was falling in line with our separation of configuration data (*parameters*) and code (*manifests*). We wanted all configuration data within **hiera** including things like *webserver* and forthcoming things like IP addresses and portnumbers.

Jeroen and Tom drafted a working solution for the role-approach and presented this (including the so-called *meta-puppet-master* - or **MPM** for short - concept on the spring-conference of the [NLUUG](http://www.nluug.nl) which can be [found in the repository](https://github.com/deltaforge/puppet-hiera-roles/blob/master/docs/Bitbrains%20%26%20Snow%20-%20Mastering%20Puppetmasters%20%26%20Roles%20-%20NLUUG%20May%202014.pdf) as well or the Dutch version of the talk captured in video [here](http://nluug.sigio.nl/05%20-%20Jeroen%20van%20Nieuwenhuizen%20-%20Tom%20Scholten%20--%20Multi-roled%20Puppetized%20Puppet%20Masters.webm "Video of talk").

## Reasoning

As explained in our talk, Bitbrains hosts a large number of customers in their own separated environments. As such these might or might not be split in more functional sub- or standalone environments (think in DTAP-terms or HA-setups regarding locations). Managing all of this through puppet was our design decision but while our **MPM**-concept saved the hassle the ever growing amount of linked roles/profiles through manifests was a burden for both engineers and operators.

Our basic concept revolves around puppet and GIT/SVN where **modules** (i.e. manifests) are the same piece of code on every DTAP environment. They are DTAP-separated by versions. So the same apache-module runs everywhere, although the version might be different. **Configuration** data, stored currently in yaml-files still, lives in a separate repository *per environment*! As such each environment will have it's own **configuration data** that, together with the **modules** comprises the current state of all targets for puppet.

## Basic concept

Our basic concept wraps around having no host-based manifests at all (which might be striving, but that's a working concept within the Bitbrains environment as we speak).

Our **site.pp** contains minimal information and just calls *hiera_include* and stitches the requested roles into a field-separated string. This as facter (at time of writing) couldn't handle arrays/hashes and as such hiera woudn't either. Note that you probably do want an **array** instead of a hash as roles might be stacked and then order does matter!

## Provided files

Along we provide several (example) files on how to set this up, our generic directory structure looks like

+ /etc/puppet/
+ /etc/puppet/**puppet.conf** (main puppet configuration file, < 3.5 add parser=future for each())
+ /etc/puppet/**hiera.yaml** (hiera file with adjusted backend and role-variable)
+ /etc/puppet/environments/
+ /etc/puppet/environments/*prd*
+ /etc/puppet/environments/prd/**site.pp** (adjusted non-manifest driven site.pp)
+ /etc/puppet/environments/prd/*forge* (modules)
+ /etc/puppet/environments/prd/*hieradata* (configuration data)
+ /etc/puppet/environments/prd/hieradata/deltaforge (bitbrains sensible defaults)
+ /etc/puppet/environments/prd/hieradata/deltaforge/**common.yaml**
+ /etc/puppet/environments/prd/hieradata/localized (customer environment specific data)
+ /etc/puppet/environments/prd/hieradata/localized/**common.yaml**
+ /etc/puppet/environments/prd/hieradata/localized/**role_webserver.yaml**
+ /etc/puppet/environments/prd/hieradata/localized/**web001.yaml**
+ /etc/puppet/environments/prd/hieradata/localized/web002.yaml
+ /etc/puppet/environments/prd/*localized* (customer specific or non-forge modules)
+ /etc/puppet/environments/*acc*/
+ (repeats ...)

# About us

Bitbrains is a company offering Cloud Platforms and High Performance computing to a diversity of customers from their offices in Amstelveen, the Netherlands. Bitbrains has merged with ASP4All in january of 2014 becoming ASP4All Bitbrains BV. More about [Bitbrains](http://www.bitbrains.com/about-us "About Bitbrains")

# Referals

Our approach has been 
+ created december 2013 and taken into our MPM environment january 2014
+ discussed with a puppet trainer during education early 2014 via Bitbrains
+ discussed during puppetcamp berlin early 2014 via ASP4all
+ presented at the forementioned NLUUG conference spring 2014 [slidedeck](https://github.com/deltaforge/puppet-hiera-roles/blob/master/docs/Bitbrains%20%26%20Snow%20-%20Mastering%20Puppetmasters%20%26%20Roles%20-%20NLUUG%20May%202014.pdf)
+ added to [HI-257](https://tickets.puppetlabs.com/browse/HI-257) upon request by wvl
+ published (github) as of spring 2014

## Similarities

We based our approach on
+ http://www.craigdunn.org/2012/05/239/
+ http://garylarizza.com/blog/2014/02/17/puppet-workflow-part-2/
+ http://puppetspecialist.nl/MPIpres/

Similar or likewise issues
+ https://github.com/puppetlabs/hiera/pull/48 (by R.I. Pienaar)
+ https://github.com/puppetlabs/hiera/pull/193 (from the above mentioned [HI-257](https://tickets.puppetlabs.com/browse/HI-257))
