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

      # Implements file system specific operations to be used by the base driver
      class FileOperations

        # Gives information about the directory content
        # @param [String] path Absolute path to the directory
        # @yield [Array] List of DirectoryItem-ish containing information about
        #   directory. Nil if there were errors or the path is not correct.
        def self.dir_contents( path )
          Dir.entries( path ).map do |filename|
            EM::FTPD::FSD::DirectoryItem.new(
              name:      filename,
              size:      File.size?( "#{path}/#{filename}" ),
              directory: File.directory?( "#{path}/#{filename}" )
            )
          end
        end

        # File size for the given file
        # @param [String] path Absolute path to file
        # @yield [Fixnum] File size or nil if there were errors or the path is not correct
        def self.bytes( path )
          File.size( path )
        end

        # Change current directory
        # @param [String] path Absolute path to the directory
        # @yield [Boolean] True if the change was correct false in other case
        def self.change_dir( path )
          !!File.directory?( path )
        end

        # Removes the given directory
        # @param [String] path Absolute path to the directory
        # @yield [Boolean] True if the deletion was correct false in other case
        def self.delete_dir( path )
          !!Dir.delete( path )
        end

        # Removes the given file
        # @param [String] path Absolute path to the file
        # @yield [Boolean] True if the deletion was correct false in other case
        def self.delete_file( path )
          !!File.delete( path )
        end

        # Moves the given file to a new location
        # @param [String] from_path Absolute path to existing file
        # @param [String] to_path Absolute path to new file
        # @yield [Boolean] True if file was moved without errors, false otherwise
        def self.rename( from_path, to_path )
          !!File.rename( from_path, to_path )
        end

        # Creates a new directory
        # @param [String] path Absolute path to the new directory
        # @yield [Boolean] True if the new directory was created false in other case
        def self.make_dir( path )
          !!Dir.mkdir( path )
        end

        # Send a file to the client
        # @param [String] path Absolute path to the file
        # @yield [String] File content or nil if the file does not exist or an error ocurred
        def self.get_file( path )
          File.read( path )
        end

        # Upload a new file to FTP server
        # @param [String] path Absolute path to final location of the file
        # @param [String] tmp_path Absolute path to temporary file created by server
        # @yield [Fixnum] New uploaded file size or false if there were an error
        def self.put_file( path, tmp_path )
          FileUtils.copy( tmp_path, path )
          File.size( tmp_path )
        end
      end
    end
  end
end
