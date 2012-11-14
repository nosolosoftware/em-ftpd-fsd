# Event Machine FTPD File System Driver
em-ftpd-fsd is a simple driver to be used with EventMachine FTP gem (em-ftpd) that use
file system as a persistence layer.

It implements basic ftp operations, authentication and callbacks (before and after)

# Usage
To use the driver, first you have to create a class that includes EM::FTPD::FSD::Base class.

    require 'em-ftpd-fsd'

    class BasicDriver
      include EM::FTPD::FSD::Base
    end

Then you can create a configuration file for em-ftpd as usual using that class as driver.

# EM-FTPD
EM-FTP is not required by this driver explicitly, you have to require it or add it to your Gemfile.
By now, em-ftpd has no activity and many forks has been created so you can pick any existing repository
not only the offically supported gem.
