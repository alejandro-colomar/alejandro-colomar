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
		sshpass -e ssh ${remote} "
			ssh-keygen -t rsa -b 4096;
		";
	done
}

function distribute_ssh_keys_to()
{
	local	accessible_machines="$1";
#	local	ssh_opts="-o PreferredAuthentications=keyboard-interactive";
#	ssh_opts="${ssh_opts} -o PubkeyAuthentication=no";

	for machine in ${accessible_machines}; do
		local	remote="${remote_user}@${machine}";
		sshpass -e ssh-copy-id -i ~/.ssh/id_rsa.pub ${remote};
	done
}

function distribute_ssh_keys_from()
{
#	ssh_opts="-o PreferredAuthentications=keyboard-interactive";
#	ssh_opts="${ssh_opts} -o PubkeyAuthentication=no";
	local	machines="$1";
	local	accessible_machines="$2";

	for machine in ${machines}; do
		local	remote="${remote_user}@${machine}";
		sshpass -e ssh ${remote} "
			$(declare -fg);
			export SSHPASS=${SSHPASS};
			distribute_ssh_keys_to	\"${accessible_machines}\";
			unset SSHPASS;
		";
	done
}

function distribute_ssh_keys()
{

	distribute_ssh_keys_from "${guis}" "${gui_accessible_machines}";
	distribute_ssh_keys_from "${managers}" "${manager_accessible_machines}";
	distribute_ssh_keys_from "${workers}" "${worker_accessible_machines}";

	for machine in ${all_machines}; do
		local	remote="${remote_user}@${machine}";
		sshpass -e ssh ${remote} "
			$(declare -fg);
			secure_ssh;
		";
	done
}

function secure_ssh()
{

	## TODO
}

function create_distribute_ssh_keys()
{

	read_ssh_password;

	create_ssh_keys;
	distribute_ssh_keys;

	unset SSHPASS;
}


################################################################################
##	end of file							      ##
################################################################################
