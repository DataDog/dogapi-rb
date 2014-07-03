require 'spec_helper'

describe "Common" do

  context "Scope" do

    it "validates the Scope class" do
      obj = Dogapi::Scope.new("somehost", "somedevice")

      expect(obj.host).to eq "somehost"
      expect(obj.device).to eq "somedevice"
    end

  end # end Scope

  context "HttpConnection" do

    it "respects the proxy configuration" do
      service = Dogapi::APIService.new("api_key", "app_key")

      service.connect do |conn|
        expect(conn.proxy_address).to be(nil)
        expect(conn.proxy_port).to be(nil)
      end

      ENV["http_proxy"] = "https://www.proxy.com:443"

      service.connect do |conn|
        expect(conn.proxy_address).to eq "www.proxy.com"
        expect(conn.proxy_port).to eq 443
      end

      ENV["http_proxy"] = nil
    end
  end

end # end Common
