#
# Author:: Alexis Sellier (<alexis.sellier@blablacar.com>)
# License:: Apache License, Version 2.0
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

Ohai.plugin(:Croc) do
  provides "croc"

  depends "network/interfaces"
  
  # Checks if user c2-user is present
  #
  # === Return
  # true:: If c2-user exists
  # false:: Otherwise
  def has_c2_user?
    so = shell_out("id c2-user")
    if so.exitstatus == 0
      true
    else
      false
    end
  rescue Ohai::Exceptions::Exec
    false
  end
    
  # Identifies the croc cloud by preferring the hint, then
  # check user
  # Returns true or false
  def looks_like_croc?
    hint?("croc") || has_c2_user?
  end
  
  collect_data do
    # Setup croc mash if it is a croc setup
    if looks_like_croc?
      Ohai::Log.debug("Plugin Croc: looks_like_croc? == true")
      croc Mash.new
    else
      Ohai::Log.debug("Plugin Croc: looks_like_croc? == false")
      nil
    end
  end
end

