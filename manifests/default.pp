class couchbase {
  exec { 'couchbase-server-source':
    command => '/usr/bin/wget http://packages.couchbase.com/releases/2.0.1/couchbase-server-enterprise_x86_64_2.0.1.deb',
    cwd => '/home/vagrant/',
    creates => '/home/vagrant/couchbase-server-enterprise_x86_64_2.0.1.deb',
    before => Package['couchbase-server']
  }

  exec { 'install-deps':
    command => '/usr/bin/apt-get install libssl0.9.8',
    before => Package['couchbase-server']
  }

  package { 'couchbase-server':
    provider => dpkg,
    ensure => installed,
    source => '/home/vagrant/couchbase-server-enterprise_x86_64_2.0.1.deb'
  }
}

node 'masternode' {
  include couchbase
  exec { 'init-couchbase-cluster':
    command => '/opt/couchbase/bin/couchbase-cli cluster-init -c 127.0.0.1:8091 --cluster-init-username=admin --cluster-init-password=password --cluster-init-ramsize=512',
    require => Package['couchbase-server']
  }

  exec { 'init-couchbase-bucket':
    command => '/opt/couchbase/bin/couchbase-cli bucket-create -c 127.0.0.1:8091 --bucket=default --bucket-type=couchbase --bucket-ramsize=256 --bucket-replica=0 -u admin -p password',
    require => Exec['init-couchbase-cluster']
  }
}

node 'node1' {
  include couchbase
  exec { 'add-node-cluster':
    command => '/opt/couchbase/bin/couchbase-cli rebalance -c 192.168.56.110 --server-add=192.168.56.101 -u admin -p password',
    require => Package['couchbase-server']
  }
}

node 'node2' {
  include couchbase
  exec { 'add-node-to-cluster':
    command => '/opt/couchbase/bin/couchbase-cli rebalance -c 192.168.56.110 --server-add=192.168.56.102 -u admin -p password',
    require => Package['couchbase-server']
  }
}

