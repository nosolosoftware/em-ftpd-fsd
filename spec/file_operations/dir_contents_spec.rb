require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#dir_contents" do
    context "when path route to existing resource" do
      before do
        ensure_dir_exist( "/test_dir" )
        ensure_file_exist( "/test_dir/test_file2" )
        ensure_file_exist( "/test_dir/test_file1" )
      end

      context "when resource is a directory" do
        it "yields an array of DirectoryItem's" do
          expect do |b|
            driver.dir_contents( "/test_dir", &b )
          end.to yield_with_args( Array )
        end
      end

      context "when resource is a file" do
        it "yields nil" do
          expect{ |b| driver.dir_contents( "/test_dir/test_file1", &b ) }.to yield_with_args( nil )
        end
      end
    end

    context "when the directory does not exist" do
      it "yields nil" do
        ensure_dir_does_not_exist( "/test_dir" )

        expect{ |b| driver.dir_contents( "/test_dir", &b ) }.to yield_with_args( nil )
      end
    end

    context "when directory is out of ftp folder" do
      it "yields nil" do
        ensure_dir_exist( "/../out_of_ftp_dir" )

        expect{ |b| driver.dir_contents( "/out_of_ftp_dir", &b ) }.to yield_with_args( nil )
      end
    end
  end
end
