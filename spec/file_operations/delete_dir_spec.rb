require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#delete_dir" do
    context "when directory exist" do
      before do
        ensure_dir_exist( "/test_dir" )
      end

      it "yields true" do
        expect{ |b| driver.delete_dir( "/test_dir", &b ) }.to yield_with_args( true )
      end

      it "deletes the directory" do
        driver.delete_dir( "/test_dir"){ |value| }
        File.directory?( FTPRoot + "/test_dir" ).should be_false
      end
    end

    context "when the directory does not exists" do
      it "yields false" do
        ensure_dir_does_not_exist( "/test_dir" )

        expect{ |b| driver.delete_dir( "/test_dir", &b ) }.to yield_with_args( false )
      end
    end

    context "when the directory is out of ftp folder" do
      before do
        ensure_dir_exist( "/../out_of_ftp_dir" )
      end

      it "yields false" do
        expect{ |b| driver.delete_dir( "/../out_of_ftp_dir", &b ) }.to yield_with_args( false )
      end

      it "does not delete the directory" do
        driver.delete_dir( "/../out_of_ftp_dir"){ |value| }
        File.directory?( FTPRoot + "/../out_of_ftp_dir" ).should be_true
      end
    end
  end
end
