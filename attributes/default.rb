#
# Copyright 2017, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# NOTE: IMPORTANT: Specific attributes related to different ceph roles (i.e., mon, radosgw, osd, cephfs)
# will be found in those attribute files.

# Change this if you want a different cluster name other than the default of ceph
default['ceph']['cluster'] = 'ceph'

# Allows for experimental things such SHEC Erasure Coding plugin in releases below Jewel.
# This will go into the global section of the ceph.conf on all nodes
default['ceph']['experimental']['enable'] = false
default['ceph']['experimental']['features'] = ['shec']

# This section controls which repo branch to use but is not in repo.rb because it also allows for changing of
# Ceph version information that is used for conditionals used in the recipes to KEEP them here.
default['ceph']['branch'] = 'stable' # Can be stable, testing or dev.
# Major release version to install or gitbuilder branch
default['ceph']['version'] = 'hammer'

default['ceph']['init_style'] = case node['platform']
                                when 'ubuntu'
                                  'upstart'
                                else
                                  'sysvinit'
                                end

default['ceph']['owner'] = 'ceph'
default['ceph']['group'] = 'ceph'
default['ceph']['mode'] = 0o0750

# NOTE: If the version is 'hammer' then change owner and group to 'root'
if node['ceph']['version'] == 'hammer'
  default['ceph']['owner'] = 'root'
  default['ceph']['group'] = 'root'
  default['ceph']['mode'] = 0o0755
end

# Override these in your environment file or here if you wish. Don't put them in the 'ceph''config''global' section.
# The public and cluster network settings are critical for proper operations.
default['ceph']['network']['public']['cidr'] = ['10.121.1.0/24']
default['ceph']['network']['cluster']['cidr'] = ['10.121.2.0/24']

# Tags are used to identify nodes for searching (unless using environments - see below)
# IMPORTANT
default['ceph']['admin']['tag'] = 'ceph-admin'
default['ceph']['radosgw']['tag'] = 'ceph-rgw'
default['ceph']['mon']['tag'] = 'ceph-mon'
default['ceph']['rbd']['tag'] = 'ceph-rbd'
default['ceph']['osd']['tag'] = 'ceph-osd'
default['ceph']['mds']['tag'] = 'ceph-mds'
default['ceph']['restapi']['tag'] = 'ceph-restapi'

# Search by environment
# Setting this to true will search for nodes by environment/attributes instead of roles/tags.
# By default, the environment searched is the value of `node.environment`, though this can
# be overriden by setting `node['ceph']['search_environment']` to the desired environment.
default['ceph']['search_by_environment'] = false

# Set the max pid since Ceph creates a lot of threads and if using with OpenStack then...
default['ceph']['system']['sysctls'] = ['kernel.pid_max=4194303', 'fs.file-max=26234859']

default['ceph']['install_debug'] = false
default['ceph']['encrypted_data_bags'] = false

default['ceph']['install_repo'] = true
default['ceph']['btrfs'] = false

case node['platform_family']
when 'debian'
  packages = ['ceph-common', 'python-pycurl']
  packages += debug_packages(packages) if node['ceph']['install_debug']
  default['ceph']['packages'] = packages
when 'rhel', 'fedora'
  packages = ['ceph', 'yum-plugin-priorities.noarch', 'python-pycurl']
  packages += debug_packages(packages) if node['ceph']['install_debug']
  default['ceph']['packages'] = packages
else
  default['ceph']['packages'] = []
end
