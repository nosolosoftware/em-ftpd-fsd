# This file is part of em-ftpd-fsd.
#
# em-ftpd-fsd is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# em-ftpd-fsd is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with em-ftpd-fsd.  If not, see <http://www.gnu.org/licenses/>.

module EM
  module FTPD
    module FSD

      # Holds different authentication mechanisims
      module Authentication

        # Simple plain authentication
        module Plain

          # Configure the authentication module
          # @param [Hash] opts
          # @option opts user Username
          # @option opts password Password
          def configure_authentication( opts )
            @auth_user     = opts[:user]
            @auth_password = opts[:password]
          end

          # Check if stored username and password validates given user and password
          # @param [String] user Username
          # @param [String] password Password
          # @yield [Boolean] True if username and password are correct
          def authenticate( user, password, &block )
            yield ( @auth_user == user && @auth_password == password )
          end
        end
      end
    end
  end
end
