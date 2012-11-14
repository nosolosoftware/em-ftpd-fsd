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

# Event Machine
module EM

  # File Transport Protocol Driver
  module FTPD

    # File System Driver
    module FSD

      # Base module to include in custom drivers
      module Base

        # Supported FTP commands.
        COMMANDS = {
          bytes:        { on_error_value: nil   },
          dir_contents: { on_error_value: nil   },
          get_file:     { on_error_value: nil   },
          change_dir:   { on_error_value: false },
          delete_dir:   { on_error_value: false },
          delete_file:  { on_error_value: false },
          rename:       { on_error_value: false },
          make_dir:     { on_error_value: false },
          put_file:     { on_error_value: false },
        }

        # Extend hooks module to load 'before' and 'after' class functions
        def self.included( klass )
          klass.extend( EM::FTPD::FSD::Hooks )
        end

        # Initiliaze the driver with basic options
        # @param [Hash] options Options
        # @option options base_path Base directory for FTP server
        # @option options authentication Authentication module to load
        # @example Default options for authentication
        #   {
        #     plain: {
        #       user:     "admin",
        #       password: "root"
        #     }
        #   }
        def initialize( options = {} )
          opts = {
            base_path: Dir.pwd,
            authentication: {
              plain: {
                user:     "admin",
                password: "root"
              }
            }
          }.merge( options )

          load_auth_module( opts[:authentication] )

          @base_path = opts[:base_path]
        end

        # Absolute path to FTP base directory.
        # @return [String] Full path to FTP base folder.
        def base_path
          File.expand_path( @base_path || "" )
        end

        # Metaprogrammed redirection to FTP commands defined by FileOperation class.
        # @param [Symbol] method Method called
        # @param [Array] args All arguments received by called method
        # @param [Block] block Block to be yield by called method
        # @raise [NoMethodError] if method is not supported by driver
        # @raise [ArgumentError] if no block is passed to yield value
        # @yield [Object] Return value from file specific operation
        def method_missing( method, *args, &block )
          raise NoMethodError, "#{method}"    unless COMMANDS.include?( method )
          raise ArgumentError, "Block needed" unless block_given?

          yield ftp_methods( method, args )
        end

        # Return true if obj respond to given method or method correspond to an
        # implemented ftp command.
        # @param [Symbol] method Given method
        # @return [Boolean] Return true if obj respond to given method.
        def respond_to?( method, include_private = false )
          super( method, include_private ) || COMMANDS.include?( method )
        end

        private

        def ftp_methods( method, args )
          # We have to map each ftp path to a local file system path to check 
          # permissions, but when command is 'put_file' the second argument
          # is an absolute path to temporary that should not be converted
          tmp_file = args.delete_at( 1 ) if method == :put_file
          args = args.map{ |arg| file_system_path( arg ) }

          begin
            # Bypass permissions for second argument if method is put_file
            args.each{ |arg| check_file_system_permissions!( arg ) }
            args.insert( 1, tmp_file ) if method == :put_file

            send( self.class.before_hooks[method], *args ) if self.class.before_hooks[method]
            value = EM::FTPD::FSD::FileOperations.send( method, *args )
            send( self.class.after_hooks[method], *(args << value) ) if self.class.after_hooks[method]

            return value
          rescue Exception
            return COMMANDS[method][:on_error_value]
          end
        end

        def file_system_path( ftp_path )
          "#{base_path}#{ftp_path}"
        end

        def check_file_system_permissions!( path )
          unless File.expand_path( path ).include? base_path
            raise SecurityError, "File system path out of FTP folder"
          end
        end

        def load_auth_module( opts )
          auth_mod = EM::FTPD::FSD::Authentication.const_get( opts.keys.first.to_s.capitalize )

          self.class.send( :include, auth_mod )
          configure_authentication( opts.values.first )
        end
      end
    end
  end
end
