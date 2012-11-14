require 'spec_helper'

describe EM::FTPD::FSD::Base do
  describe "included methods" do
    subject{ BasicDriver.new( DriverConfig ) }

    it{ should respond_to( :authenticate ) }
    it{ should respond_to( :dir_contents ) }
    it{ should respond_to( :delete_file ) }
    it{ should respond_to( :change_dir ) }
    it{ should respond_to( :delete_dir ) }
    it{ should respond_to( :make_dir ) }
    it{ should respond_to( :get_file ) }
    it{ should respond_to( :put_file ) }
    it{ should respond_to( :rename ) }
    it{ should respond_to( :bytes ) }
  end
end
