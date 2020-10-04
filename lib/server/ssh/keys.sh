################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
##	source								      ##
################################################################################


################################################################################
##	definitions							      ##
################################################################################
remote_user="ubuntu";
guis="
	gui0
";
managers="
	manager0
	manager1
	manager2
";
workers="
	worker0
	worker1
	worker2
";
all_machines="${guis} ${managers} ${workers}";
gui_accessible_machines="${all_machines}";
manager_accessible_machines="${managers} ${workers}";
worker_accessible_machines="${workers}";


################################################################################
##	functions							      ##
################################################################################
## XXX: Pair calls to this function with "unset SSHPASS"!!!
function read_ssh_password()
{

echo	"This script will set up keyless ssh."
echo	"After this script, ssh will not accept passwords again."
echo	"Enter the current password for ssh connections."

read -s -p "Password to use: " SSHPASS;
export SSHPASS;
}

function create_ssh_keys()
{

	for machine in ${all_machines}; do
		local	remote="${remote_user}@${machine}";
		sshpass -e ssh ${remote} <<-'END_SSH'
			ssh-keygen -t rsa -b 4096;
		END_SSH
	done

	unset SSHPASS;
}

function distribute_ssh_keys_to()
{
#	ssh_opts="-o PreferredAuthentications=keyboard-interactive";
#	ssh_opts="${ssh_opts} -o PubkeyAuthentication=no";
	accessible_machines="$1";

	export SSHPASS;

	for machine in ${accessible_machines}; do
		local	remote="${remote_user}@${machine}";
		sshpass -e ssh-copy-id -i ~/.ssh/id_rsa.pub ${remote};
	done

	unset SSHPASS;
}

function distribute_ssh_keys_from()
{
#	ssh_opts="-o PreferredAuthentications=keyboard-interactive";
#	ssh_opts="${ssh_opts} -o PubkeyAuthentication=no";
	machines="$1";
	accessible_machines="$2";

	for machine in ${machines}; do
		local	remote="${remote_user}@${machine}";
		sshpass -e ssh ${remote} <<-'END_SSH'
			$(declare -fg);
			distribute_ssh_keys_to	"${accessible_machines}";
		END_SSH
	done
}

function distribute_ssh_keys()
{

	export SSHPASS;

	distribute_ssh_keys_from "${guis}" "${gui_accessible_machines}";
	distribute_ssh_keys_from "${managers}" "${manager_accessible_machines}";
	distribute_ssh_keys_from "${workers}" "${worker_accessible_machines}";

	for machine in ${all_machines}; do
		local	remote="${remote_user}@${machine}";
		sshpass -e ssh ${remote} <<-'END_SSH'
			$(declare -fg);
			secure_ssh;
		END_SSH
	done

	unset SSHPASS;
}

function secure_ssh()
{

	## TODO
}

function create_distribute_ssh_keys()
{

	read_ssh_password;

	export SSHPASS;

	create_ssh_keys;
	distribute_ssh_keys;

	unset SSHPASS;
}


################################################################################
##	end of file							      ##
################################################################################
