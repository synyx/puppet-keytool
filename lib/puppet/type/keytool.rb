module Puppet
  newtype(:keytool) do

    @doc = 'Manages certificates in a java keystore via keytool.'

    ensurable do
      desc 'Has two states, present and absent.'

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.destroy
      end

      defaultto :present
    end

    newparam(:name) do
      desc 'The alias that is used to identify the entry in the keystore.  We
        are down casing it for you here because keytool will do so for you too.'

      isnamevar

      munge do |value|
        value.downcase
      end
    end

    newparam(:certificate) do
      desc 'An already signed certificate that we can place in the keystore.  We
        autorequire the file for convenience.'

      isrequired
    end

    newparam(:password) do
      desc 'The password used to protect the keystore.'

      defaultto :changeit

      validate do |value|
        raise Puppet::Error, "password is #{value.length} characters long; must be of length 6 or greater" if value.length < 6
      end
    end

    newparam(:java_home) do
      desc "Variable to point to the JRE installation directory"
    end

    # Where we setup autorequires.
    autorequire(:file) do
      auto_requires = []
      [:certificate].each do |param|
        if @parameters.include?(param)
          auto_requires << @parameters[param].value
        end
      end
      auto_requires
    end

  end
end
