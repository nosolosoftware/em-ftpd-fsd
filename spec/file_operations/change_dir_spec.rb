require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#change_dir" do
    context "when the directory exist" do
      it "yields true" do
        ensure_dir_exist( "/test_dir" )

        expect{ |b| driver.change_dir( "/test_dir", &b ) }.to yield_with_args( true )
      end
    end

    context "when the directory does not exists" do
      it "yields false" do
        ensure_dir_does_not_exist( "/test_dir" )

        expect{ |b| driver.change_dir( "/test_dir", &b ) }.to yield_with_args( false )
      end
    end

    context "when the directory is out of ftp folder" do
      it "yields false" do
        ensure_dir_exist( "/../out_of_ftp_dir" )

        expect{ |b| driver.change_dir( "/../out_of_ftp_dir", &b ) }.to yield_with_args( false )
      end
    end
  end
end
