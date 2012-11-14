describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#rename" do
    context "when the source file exist" do
      before do
        ensure_file_exist( "/test_file" )
      end

      context "when the destination file does not exist" do
        before do
          ensure_file_does_not_exist( "/renamed" )
        end

        it "yield true" do
          expect{ |b| driver.rename( "/test_file", "/renamed", &b ) }.to yield_with_args( true )
        end

        it "renames the source file to destination file" do
          driver.rename( "/test_file", "/renamed" ){ |value| }
          File.exist?( FTPRoot + "/test_file" ).should be_false
          File.exist?( FTPRoot + "/renamed" ).should be_true
        end
      end

      context "when the destination file do exist" do
        before do
          ensure_file_exist( "/renamed" )
        end

        it "yield true" do
          expect{ |b| driver.rename( "/test_file", "/renamed", &b ) }.to yield_with_args( true )
        end

        it "renames the source file" do
          driver.rename( "/test_file", "/renamed" ){ |value| }
          File.exist?( FTPRoot + "/test_file" ).should be_false
          File.exist?( FTPRoot + "/renamed" ).should be_true
        end
      end
    end

    context "when the source file does not exist" do
      before do
        ensure_file_does_not_exist( "/test_file" )
        ensure_file_does_not_exist( "/renamed" )
      end

      it "yield false" do
        expect{ |b| driver.rename( "/test_file", "/renamed", &b ) }.to yield_with_args( false )
      end
    end

    context "when source path is out of ftp folder" do
      before do
        ensure_file_exist( "/../out_of_ftp_file" )
        ensure_file_does_not_exist( "/renamed" )
      end

      it "yield false" do
        expect{ |b| driver.rename( "/../out_of_ftp_file", "/renamed", &b ) }.to yield_with_args( false )
      end
    end

    context "when destination path is out of ftp folder" do
      before do
        ensure_file_exist( "/tets_file" )
        ensure_file_does_not_exist( "/../out_of_ftp_file" )
      end

      it "yield false" do
        expect{ |b| driver.rename( "/test_file", "/../out_of_ftp_file", &b ) }.to yield_with_args( false )
      end
    end
  end
end
