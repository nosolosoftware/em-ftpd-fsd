require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#delete_file" do

    context "when the file exist" do
      before do
        ensure_file_exist( "/test_file" )
      end

      it "yields true" do
        expect{ |b| driver.delete_file( "/test_file", &b ) }.to yield_with_args( true )
      end

      it "deletes the file" do
        driver.delete_file( "/test_file"){ |value| }
        File.exist?( FTPRoot + "/test_file" ).should be_false
      end
    end

    context "when the file does not exists" do
      it "yields false" do
        ensure_file_does_not_exist( "/test_file" )
        expect{ |b| driver.delete_file( "/test_file", &b ) }.to yield_with_args( false )
      end
    end

    context "when the file is out of ftp folder" do
      before do
        ensure_file_exist( "/../out_of_ftp_file" )
      end

      it "yields false" do
        expect{ |b| driver.delete_file( "/../out_of_ftp_file", &b ) }.to yield_with_args( false )
      end

      it "does not delete the file" do
        driver.delete_file( "/test_file"){ |value| }
        File.exist?( FTPRoot + "/../out_of_ftp_file" ).should be_true
      end
    end
  end
end
