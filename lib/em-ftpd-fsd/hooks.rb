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

      # Add callbacks methods to base class.
      # @example Usage
      #   class BasicDriver
      #     include EM::FTPD::FSD::Base
      #
      #     before :put_file, :some_method
      #     after :delete_file, :some_other_method
      #
      #     def some_method( path, tmp_path )
      #       ...
      #     end
      #
      #     def some_other_method( path, value )
      #       ...
      #     end
      #   end
      module Hooks

        # Set a method to be called before FTP command is executed
        # That method will be invoked with same arguments that FTP command
        # @param [Symbol] command FTP command to be hooked
        # @param [Symbol] method Method to be called before FTP command
        def before( command, method )
          before_hooks[command] = method
        end

        # Set a method to be called after FTP command is executed
        # That method will be invoked with same arguments that FTP command and
        # an extra parameter containig the value yielded by the FTP command
        # @param [Symbol] command FTP command to be hooked
        # @param [Symbol] method Method to be called after FTP command
        def after( command, method )
          after_hooks[command] = method
        end

        # Defined hooks to be executed before FTP commands
        # @return [Array] List of methods to be called before FTP commands
        def before_hooks
          @before_hooks ||= {}
        end

        # Defined hooks to be executed after FTP commands
        # @return [Array] List of methods to be called after FTP commands
        def after_hooks
          @after_hooks ||= {}
        end
      end
    end
  end
end
