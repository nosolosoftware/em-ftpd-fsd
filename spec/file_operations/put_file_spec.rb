require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#put_file" do
    context "when the destination file does not exist" do
      before do
        ensure_file_does_not_exist( "/new_file" )
        ensure_file_exist( "/tmp_file" )
      end

      it "yields an integer indicating the number of bytes received" do
        file_size = File.size( FTPRoot + "/tmp_file" )

        expect{ |b| driver.put_file( "/new_file", FTPRoot + "/tmp_file", &b ) }.to yield_with_args( file_size )
      end

      it "creates a new file in destination path" do
        driver.put_file( "/new_file", FTPRoot + "/tmp_file" ){ |value| }

        File.exist?( FTPRoot + "/new_file" ).should be_true
      end
    end

    context "when the destination file already exist" do
      before do
        ensure_file_exist( "/new_file" )
        ensure_file_exist( "/tmp_file" )
      end

      it "yields an integer indicating the number of bytes received" do
        file_size = File.size( FTPRoot + "/tmp_file" )

        expect{ |b| driver.put_file( "/tmp_file", FTPRoot + "/new_file", &b ) }.to yield_with_args( file_size )
      end

      it "creates a new file in destination path" do
        driver.put_file( "/new_file", "/tmp_file" ){ |value| }

        File.exist?( FTPRoot + "/new_file" ).should be_true
      end
    end

    context "when destination path is out of ftp folder" do
      before do
        ensure_file_exist( "/../out_of_ftp_file" )
        ensure_file_exist( "/tmp_file" )
      end

      it "yields nil" do
        expect{ |b| driver.put_file( "/new_file", "/../out_of_ftp_file", &b ) }.to yield_with_args( false )
      end
    end
  end
end
