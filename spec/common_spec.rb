require 'spec_helper'

describe "Common" do

  context "Scope" do

    it "validates the Scope class" do
      obj = Dogapi::Scope.new("somehost", "somedevice")

      expect(obj.host).to eq "somehost"
      expect(obj.device).to eq "somedevice"
    end

  end # end Scope

end # end Common
