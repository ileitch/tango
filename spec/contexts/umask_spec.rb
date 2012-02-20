require 'tango'

module Tango::Contexts
  describe Umask do

    before do
      stub_class = Class.new do
        include Helpers
      end
      @stub = stub_class.new

      # Make double sure we reset the umask after each test.
      @original_umask = File.umask
    end

    after do
      File.umask(@original_umask)
    end

    it "should change the umask" do
      @stub.with_umask(0777) do
        File.umask.should == 0777
      end
    end

    it "should restore the original umask" do
      old_umask = File.umask
      @stub.with_umask(0777) { }
      File.umask.should == old_umask
    end

    it 'exposes the umask' do
      Umask.new(0644).umask.should == 0644
    end
  end
end
