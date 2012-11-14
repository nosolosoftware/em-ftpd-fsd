require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#bytes" do
    context "when the file exist" do
      it "yields the size of the specified file" do
        ensure_file_exist( "/test_file" )

        expect do |b|
          driver.bytes( "/test_file", &b )
        end.to yield_with_args( File.size( FTPRoot + "/test_file" ) )
      end
    end

    context "when the file does not exist" do
      it "yields nil" do
        ensure_file_does_not_exist( "/test_file" )

        expect{ |b| driver.bytes( "/test_file", &b ) }.to yield_with_args( nil )
      end
    end

    context "when the file is out of ftp folder" do
      it "yields nil" do
        ensure_file_exist( "/../out_of_ftp_file" )

        expect{ |b| driver.bytes( "/../out_of_ftp_file", &b ) }.to yield_with_args( nil )
      end
    end
  end
end
