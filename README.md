keytool
=======

Overview
--------

The keytool module uses keytool to manage entries in the JRE keystore. It's a Puppet provider called `keytool`, which can import and delete ssl certificates of the JRE keystore.

This provider is based on https://github.com/puppetlabs/puppetlabs-java_ks.


Usage
-----

Import a new certificate in the JRE keystore

```puppet
file {'/path/to/your/certificate.cer':
  ensure  => file,
  content =>'Paste your signed ssl certificate here',
}

keytool {'certificate.cer':
  ensure      => present,
  certificate => '/path/to/your/certificate.cer',
  java_home   => '/path/to/your/jre'
}
```

Delete existing certificate in the JRE keystore

```puppet
file {'/path/to/your/certificate.cer':
  ensure  => file,
  content =>'Paste your signed ssl certificate here',
}

keytool {'certificate.cer':
  ensure      => absent,
  certificate => '/path/to/your/certificate.cer',
  java_home   => '/path/to/your/jre'
}
```


Parameters
----------

#### `ensure`

The `ensure` parameter accepts two attributes: absent, present.

#### `name`

The alias that is used to identify the entry in the keystore.

#### `certificate`

An already-signed certificate file to place in the keystore. This file must be present on the node.


#### `password`

The password used to protect the keystore. Default value is `changeit`.

#### `java_home`

The path to point to the JRE installation directory. If the parameter is not given, the java home location is determined via /etc/alternatives.

