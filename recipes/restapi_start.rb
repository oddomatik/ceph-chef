#
# Author:: Chris Jones <cjones303@bloomberg.net>
# Cookbook Name:: ceph
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

# IMPORTANT: The ceph-rest-api process is a Python script running with WSGI. This is ok for fairly small number of
# requests. Since this is only for Admin functionaility it should not be hit a lot. IF you plan on this process to
# hit from a high number of clients with a good number of requests then it's recommend that you create multiple
# processes and use something like NGINX in front so that it proxies to collection of processes. This will provide
# a more scalable option.

case node['platform_family']
when 'rhel'
  service 'ceph_rest_api' do
    service_name 'ceph-rest-api'
    provider Chef::Provider::Service::Systemd
    supports :restart => true, :status => true
    action [:enable, :start]
    subscribes :restart, "template[/etc/ceph/#{node['ceph']['cluster']}.conf]"
  end
when 'debian'
  execute 'restapi-start' do
    command 'nohup ceph-rest-api &'
    not_if 'pgrep ceph-rest-api'
  end
end
