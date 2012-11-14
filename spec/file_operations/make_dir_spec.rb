require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#make_dir" do

    context "when directory does not exist" do
      before do
        ensure_dir_does_not_exist( "/test_dir" )
      end

      it "yields true" do
        expect{ |b| driver.make_dir( "/test_dir", &b ) }.to yield_with_args( true )
      end

      it "creates the directory" do
        driver.make_dir( "/test_dir"){ |value| }
        File.directory?( FTPRoot + "/test_dir" ).should be_true
      end
    end

    context "when the directory exists" do
      it "yields false" do
        ensure_dir_exist( "/test_dir" )

        expect{ |b| driver.make_dir( "/test_dir", &b ) }.to yield_with_args( false )
      end
    end

    context "when the directory is out of ftp folder" do
      before do
      ensure_dir_does_not_exist( "/../out_of_ftp_dir" )
      end
      it "yields false" do
        expect{ |b| driver.make_dir( "/../out_of_ftp_dir", &b ) }.to yield_with_args( false )
      end

      it "does not create the directory" do
        driver.make_dir( "/../out_of_ftp_dir" ){ |value| }
        File.directory?( FTPRoot + "/../out_of_ftp_dir" ).should be_false
      end
    end


  end
end
