#
# Cookbook:: apache2
# Resource:: apache2_conf
#
# Copyright:: 2008-2017, Chef Software, Inc.
# Copyright:: 2018, Webb Agile Solutions Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
property :file_location, String, default: '/usr/local/bin/apache2_module_conf_generate.pl'

action :create do
  unless platform_family?('debian')
    cookbook_file new_resource.file_location do
      source 'apache2_module_conf_generate.pl'
      mode '0750'
      owner 'root'
      group new_resource.root_group
    end
  end
end

action :execute do
  execute 'generate-module-list' do
    command "#{new_resource.file_location} #{lib_dir} #{apache_dir}/mods-available"
    action :run
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end