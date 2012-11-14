require 'spec_helper'

describe EM::FTPD::FSD::Base do
  class BasicDriver
    before :delete_file, :some_method
    after :make_dir, :some_other

    def some_method( file )
    end

    def some_other( dir, value )
    end
  end

  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "Hooks" do
    context "when a before hooked ftp command is called" do
      it "also calls the given method with passed arguments" do
        ensure_file_exist( "/test_file" )

        driver.should_receive( :some_method ).with( File.expand_path( FTPRoot + "/test_file" ) )
        driver.delete_file( "/test_file" ){ |value| }
      end
    end

    context "when an after hooked ftp command is called" do
      it "also calls the given method with passed arguments and yielded value" do
        ensure_dir_does_not_exist( "/test_dir" )

        driver.should_receive( :some_other ).with( File.expand_path( FTPRoot + "/test_dir" ), true )
        driver.make_dir( "/test_dir" ){ |value| }
      end
    end

  end
end
