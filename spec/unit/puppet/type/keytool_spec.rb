require 'spec_helper'

describe Puppet::Type.type(:keytool) do

  describe 'when validating attributes' do
    [ :name, :certificate, :password, :java_home ].each do |param|
      it "should have a #{param} parameter" do
        expect(Puppet::Type.type(:keytool).attrtype(param)).to eq(:param)
      end
    end

    [ :ensure ].each do |prop|
      it "should have a #{prop} property" do
        expect(Puppet::Type.type(:keytool).attrtype(prop)).to eq(:property)
      end
    end

  end

  describe 'namevar validation' do
    it 'should have :name as its namevar' do
      expect(Puppet::Type.type(:keytool).key_attributes).to eq([:name])
    end
  end

  describe 'when validating attribute values' do

    describe 'ensure' do
      [:present, :absent].each do |value|
        it "should support #{value} as a value to ensure" do
          expect { Puppet::Type.type(:keytool).new({
            :name   => 'example',
            :ensure => value,
          })}.to_not raise_error
        end
      end

      it 'should not support other values' do
        expect { Puppet::Type.type(:keytool).new({
            :name   => 'example',
            :ensure => 'foo',
          })}.to raise_error(Puppet::Error, /Invalid value/)
      end

      it 'defaults to present' do
        expect( Puppet::Type.type(:keytool).new({
          :name => 'example'
        })[:ensure] ).to eq :present
      end

    end
  end

  describe 'name' do
    it 'should downcase value' do
      expect( Puppet::Type.type(:keytool).new({
        :name => 'EXAMPLE'
      })[:name] ).to eq 'example'
    end
  end

  describe 'password' do
    it 'should not support values with less than 6 characters' do
      expect { Puppet::Type.type(:keytool).new({
        :name     => 'example',
        :password => 'foopw',
      })}.to raise_error(Puppet::Error, /Parameter password/)
    end

    it 'should support value with at least 6 characters' do
      expect { Puppet::Type.type(:keytool).new({
        :name     => 'example',
        :password => 'foosix',
      })}.to_not raise_error
    end

    it 'should default to changeit' do
      expect( Puppet::Type.type(:keytool).new({
        :name => 'example'
      })[:password] ).to eq :changeit
    end
  end
end
