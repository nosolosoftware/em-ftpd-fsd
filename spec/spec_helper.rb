# Require code coverage using .simplecov file
require 'simplecov'

# REquire the gem itself
require 'em-ftpd-fsd'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

# Set up FTP folder
FTPRoot = "#{File.dirname( __FILE__ )}/support/ftp_root"

# Basic driver configuration
DriverConfig = {
  base_path: FTPRoot,
  authentication: {
    plain: {
      user: "admin",
      password: "root"
    }
  }
}

# Dummy class to do the testing
class BasicDriver
  include EM::FTPD::FSD::Base
end

RSpec.configure do |config|
  config.include FilesHelper

  # Prepare the file system for test
  config.before :suite do
    Dir.mkdir( FTPRoot ) unless File.directory?( FTPRoot )
  end

  config.after :suite do
    File.delete( FTPRoot + "/../out_of_ftp_file" ) if File.exist?( FTPRoot + "/../out_of_ftp_file" )
    FileUtils.rm_rf( FTPRoot + "/../out_of_ftp_dir" ) if File.exist?( FTPRoot + "/../out_of_ftp_dir" )
    FileUtils.rm_rf( FTPRoot )
  end
end
