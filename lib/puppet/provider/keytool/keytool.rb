require 'puppet/util/filetype'

Puppet::Type.type(:keytool).provide(:keytool) do

  desc 'Uses keytool to manage a JVM keystore'

  def command_keytool
    'keytool'
  end

  def keystore
    "#{java_home}/lib/security/cacerts"
  end

  def java_home
    if !@resource[:java_home].nil? and !@resource[:java_home].empty?
      @resource[:java_home]
    else
      `readlink -f /etc/alternatives/java | sed 's:/bin/java::'`.chomp
    end
  end

  def exists?
    cmd = [
      command_keytool,
      '-list',
      '-alias', @resource[:name],
      '-keystore', keystore,
      '-storepass', @resource[:password],
    ]

    begin
      run_command(cmd)
      return true
    rescue
      return false
    end
  end

  def create
    cmd = [
      command_keytool,
      '-importcert', '-noprompt',
      '-file', @resource[:certificate],
      '-alias', @resource[:name],
      '-keystore', keystore,
      '-storepass', @resource[:password],
    ]

    run_command(cmd)
  end

  def destroy
    cmd = [
      command_keytool,
      '-delete',
      '-alias', @resource[:name],
      '-keystore', keystore,
      '-storepass', @resource[:password],
    ]

    run_command(cmd)
  end

  def run_command(cmd)
    options = {
      :failonfail => true,
      :combine => true ,
      :custom_environment => {
        'PATH' => "#{java_home}/bin:#{ENV['PATH']}"
      }
    }

    Puppet::Util::Execution.execute(cmd, options)
  end

end
