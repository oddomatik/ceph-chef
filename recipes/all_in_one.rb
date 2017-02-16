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

include_recipe 'ceph::mon_install'
include_recipe 'ceph::mon'
include_recipe 'ceph::mon_keys'
include_recipe 'ceph::mon_start'
include_recipe 'ceph::osd_install'
include_recipe 'ceph::osd'
include_recipe 'ceph::osd_start'
include_recipe 'ceph::mds_install'
include_recipe 'ceph::mds'
include_recipe 'ceph::cephfs'
include_recipe 'ceph::radosgw_install'
include_recipe 'ceph::radosgw'
include_recipe 'ceph::radosgw_start'
include_recipe 'ceph::restapi_install'
include_recipe 'ceph::restapi'
include_recipe 'ceph::restapi_start'
