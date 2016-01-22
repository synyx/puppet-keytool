#!/usr/bin/env rspec
require 'spec_helper'
require 'bourne'

describe Puppet::Type.type(:keytool).provider(:keytool) do

  describe 'keystore' do
    it 'should find keystore location for given java_home' do
      r = Puppet::Type.type(:keytool).new({
        :name        => 'example.com',
        :java_home   => '/java/home',
        :certificate => '/tmp/example.com.cer',
        :provider    => described_class.name
      })
      p = r.provider
      expect(p.keystore).to eq '/java/home/lib/security/cacerts'
    end

    it 'should find keystore location without given java_home' do
      r = Puppet::Type.type(:keytool).new({
        :name        => 'example.com',
        :certificate => '/tmp/example.com.cer',
        :provider    => described_class.name
      })
      p = r.provider
      p.stubs(:`).returns "/system/java/home\n"
      expect(p.keystore).to eq '/system/java/home/lib/security/cacerts'
      expect(p).to have_received(:`).with("readlink -f /etc/alternatives/java | sed 's:/bin/java::'")
    end

  end
end
