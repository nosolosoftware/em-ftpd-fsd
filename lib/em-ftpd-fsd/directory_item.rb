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

      # This is a copy of original DirectoryItem class found in yob's repository.
      # The goal of duplication is not to required em-ftpd.
      #
      # Given gem official repository is not active and there are a lot of forks
      # it is better to redefine this class here and be able to use em-ftpd from any
      # source that tie the entire driver to a one repository.
      class DirectoryItem

        # Fields for DirectoryItem
        ATTRS = [:name, :owner, :group, :size, :time, :permissions, :directory]

        attr_accessor(*ATTRS)

        # Initializer method
        # @param [Hash] options
        # @option options name
        # @option options name
        # @option options owner
        # @option options group
        # @option options size
        # @option options time
        # @option options permissions
        # @option options directory
        def initialize(options)
          options.each do |attr, value|
            self.send("#{attr}=", value)
          end
        end
      end

    end
  end
end
