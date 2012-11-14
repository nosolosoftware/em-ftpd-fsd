describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }

  describe "#get_file" do
    context "when file exist" do
      it "yields a string with the file data to send to the client" do
        ensure_file_exist( "/test_file" )

        expect{ |b| driver.get_file( "/test_file", &b ) }.to yield_with_args(
          File.read( FTPRoot + "/test_file" )
        )
      end
    end

    context "when file does not exist" do
      it "yields nil" do
        ensure_file_does_not_exist( "/test_file" )

        expect{ |b| driver.get_file( "/test_file", &b ) }.to yield_with_args( nil )
      end
    end

    context "when file is out of ftp folder" do
      it "yields nil" do
        ensure_file_exist( "/../out_of_ftp_file" )

        expect{ |b| driver.get_file( "/../out_of_ftp_file", &b ) }.to yield_with_args( nil )
      end
    end
  end
end
