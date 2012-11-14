require 'spec_helper'

describe EM::FTPD::FSD::Base do
  let( :driver ){ BasicDriver.new( DriverConfig ) }


  # The driver has been configured in spec_helper using
  #   user     admin
  #   password root
  describe "#authenticate" do
    context "when user and password are correct" do
      it "yield true" do
        expect{ |b| driver.authenticate( "admin", "root", &b ) }.to yield_with_args( true )
      end
    end

    context "when user is not correct" do
      it "yield false" do
        expect{ |b| driver.authenticate( "root", "root", &b ) }.to yield_with_args( false )
      end
    end

    context "when password is not correct" do
      it "yield false" do
        expect{ |b| driver.authenticate( "admin", "admin", &b ) }.to yield_with_args( false )
      end
    end

    context "when neither user nor password are correct" do
      it "yield false" do
        expect{ |b| driver.authenticate( "god", "1234", &b ) }.to yield_with_args( false )
      end
    end
  end
end
