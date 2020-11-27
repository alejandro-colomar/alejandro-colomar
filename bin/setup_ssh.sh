#!/bin/bash
set -Eeo pipefail
##	./bin/setup_ssh.sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Configure ssh network
## =====================
##
##	Run this script from a guiX machine
##
################################################################################


################################################################################
##	source								      ##
################################################################################
source	lib/libalx/sh/sysexits.sh;


################################################################################
##	definitions							      ##
################################################################################
ARGC=0;

guis=(gui0);
managers=(manager0 manager1 manager2);
workers=(worker0 worker1 worker2);
all_machines="${guis[@]} ${managers[@]} ${workers[@]}";
gui_accessible_machines="${all_machines}";
manager_accessible_machines="${managers[@]} ${workers[@]}";
worker_accessible_machines="${workers[@]}";

ssh_opts='-o StrictHostKeyChecking=no';


################################################################################
##	functions							      ##
################################################################################
## XXX: Pair calls to this function with "unset SSHPASS"!!!
function read_ssh_password()
{

	echo "This script will set up keyless ssh."
	echo "After this script, ssh will not accept passwords again."
	echo "Enter the current password for ssh connections."

	read -s -p "Password to use: " SSHPASS;
	echo;
	export SSHPASS;
}

function create_ssh_keys()
{

	for remote in ${all_machines}; do
		echo "	SSH-KEYGEN	${remote};"
		sshpass -e ssh ${ssh_opts} ${remote} "
			ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P '' ||:;
		";
	done
}

function distribute_ssh_keys_to()
{
	local	accessible_machines="$1";

	for remote in ${accessible_machines}; do
		echo "	SSH-COPY-ID	$(cat /etc/hostname)	${remote};"
		sshpass -e ssh-copy-id -i ~/.ssh/id_rsa.pub ${ssh_opts}	\
					${remote}			\
		2>&1 | grep -e WARNING -e ERROR -e 'Number of key(s) added:';
	done
}

function distribute_ssh_keys_from()
{
	local	machines="$1";
	local	accessible_machines="$2";

	for remote in ${machines}; do
		sshpass -e ssh -n ${ssh_opts} ${remote} "
			set -Eeo pipefail
			$(declare -fg);
			export SSHPASS=\"${SSHPASS}\";
			ssh_opts=\"${ssh_opts}\";
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

	for remote in ${all_machines}; do
		ssh -n ${remote} "
			$(declare -fg);
			secure_ssh;
		";
	done
}

function secure_ssh()
{

	:; ## TODO
}

function create_distribute_ssh_keys()
{

	read_ssh_password;
	create_ssh_keys;
	distribute_ssh_keys;

	unset SSHPASS;
}


################################################################################
##	main								      ##
################################################################################
function main()
{

	create_distribute_ssh_keys;
}


################################################################################
##	run								      ##
################################################################################
argc=$#;
if [ ${argc} -ne ${ARGC} ]; then
	echo	"Illegal number of parameters (Requires ${ARGC})";
	exit	${EX_USAGE};
fi

main;


################################################################################
##	end of file							      ##
################################################################################
