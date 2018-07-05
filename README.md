# clone12_2
Oracle Rapid Clone for EBS 12.2 installation on AIX 7.2

##Description


Dependency: cookbook aix 2.3.1 chef_client: 13.9.1

Note: This cookbook is heavily dependent on:
 'Cloning Oracle E-Business Suite Release 12.2 with Rapid Clone (Doc ID 1383621.1)'
 Please read this document to understand the tasks completed by this cookbook.


clone12_2 COOKBOOK Limitations:

  * Does not support Oracle Database RAC option.
  * Does not support a multi-tier/lpar installation.
  * Has not been tested on any other operating systems other than AIX 7.2
  * Installs both application and database on the same LPAR under user 'oracle'
  * Must have a working EBS 12.2 Source environment that you whish to clone.

NOTE: Oracle E-Business Suite requires valid licenses to install.
It is expected that the user of this cookbook follows all licensing
requirements of Oracle EBS.

##Quickstart (EBS)

* Have either an open Source Chef Server or a Hosted Chef account at the ready.
* Create your Target machine with AIX 7.2 operating system.
* Follow Oracle document ID  1383621.1. (Aug 1 2016)
* It is assumed that all the operations from Section 1 to 
  Section 3.2 have been completed on the SOURCE machine 
  and then a compressed tar image is copied and available on the Target machine
* Create your staging directory on the Target AIX 7.2 LPAR


```'
  clone12_2.rb (Role file)
  ----------------------------------------------------------------------
name 'cl50'
description 'Role applied to clone of EBS'

run_list 'recipe[clone12_2]'

override_attributes(
 {
   'clone12_2' => {
      # Provides support for versions
      # options are 1226 and 1227. Default is 1227
      'wget_version' => '1227',
      # 
      # Expects 2 disks of 400GB each. 2 Files systems /d01 installs EBS
      # /d02 is the staging directory for installation.
      'machprep' => {
         'newvgs'       =>  [
              #    vgname,     ppsiz(MB),                 hdisks [,,]
              #----------      ----------     -----------------------
                'ebsclone',         '128',     [ 'hdisk1', 'hdisk2', ]
           ],
         'newfs'        =>  [
                #mountpoint         size        volgroup    logfile   logsize(MB)
                #__________   __________      __________    _______   ___________
                     '/d01',      '395G',      'ebsclone',  'd01log', '800',
                     '/d02',      '395G',      'ebsclone',  'd02log', '800',
           ],
       },
      # will write the /etc/hosts entries with thes values
      # Modify the values to your environment. These are just for example.
      'ebsprep'            => {
         'etchosts'        => {
             'triplets'    => [
               '127.0.0.1',        'localhost.localdomain',        [ 'localhost', 'loopback',],
               '192.168.1.11',    'hostname.pbm.ihost.com',         [ 'hostname',],
               ]
               }
       }
    }
 }
)

  ----------------------------------------------------------------------
```

* Bootstrap the node, telling Chef to install itself, and install the 
  Oracle E-Business Suite environment for the DEMO Database, 'VIS'.


  Ex: knife bootstrap <TargetNode> -x root -P <password> --bootstrap-version 13.9.1 \
        -N <TargetNode> -r 'role[cl50]' -y -V
      where <TARGETNODE> is the AIX 7.2 target LPAR.

* This Install will take plenty of time, so find a good book to read.
  (On my fastest machine, it took over 12 hours, on slower machines/disks, can be 20 hours)


#Requirements

## Oracle EBS:

  New Oracle E-Business Suite R12 Operating System and Tools Requirements 
  on IBM AIX on Power Systems (Doc ID 1294357.1)

## Chef

The clone12_2 cookbook was tested using:
   chef_dk:       3.0.36-1
   chef_server: 12.17.33-1
   chef_client:     13.9.1

## Platforms

* AIX 7.2 

Note: clone12_2 cookbook has not been tested on AIX 7.1, and 6.1.

## DOCUMENTATION/FILES


# Miscellaneous

## Recipes

Follow the file recipes/default.rb for the order of included recipe files

##Usage Notes

* .rsp files are used. Feel free to replace response files with your own

Contributing
============

1. Fork the repository on Github: (https://github.com/jkohlmeier/clone12_2)
2. Create a named feature branch (like `add_component_x`)
3. Write your changes
4. Write tests for your changes (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
===================

* Author:: Jubal Kohlmeier <jubal@us.ibm.com>  

Copyright:: 2018, Jubal Kohlmeier

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
