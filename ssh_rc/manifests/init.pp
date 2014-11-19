class ssh_rc ($trusted_home,$trusted_user,$command_visudo=undef) {
        
	file {"${trusted_home}/.ssh":
		ensure => directory,
		owner  => $trusted_user,
		group  => $trusted_user,
		mode   => 700
	}
	
	file {"${trusted_home}/.ssh/authorized_keys":
		ensure  => present,
		source  => 'puppet:///modules/ssh_rc/authorized_keys',
		mode    => 600,
		owner   => $trusted_user,
		group   => $trusted_user,
		require => File["${trusted_home}/.ssh"]
	}
	exec {"selinux":
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		command => "setenforce 0",
        }
        exec {'chage':
		path	=> "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		command => "chage -M99999 -m99999 ${trusted_user}",
	}
	if $command_visudo != undef {
 		file_line {"visudo":
   			ensure => present,
   			line  => "${trusted_user} ${command_visudo}",
   			path  => "/etc/sudoers",
			tag   => 'visudo',
 		}
	}
}
		
