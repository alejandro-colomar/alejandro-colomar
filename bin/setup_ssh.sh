#!/bin/bash
set -Eeo pipefail;
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
.	lib/libalx/sh/sysexits.sh;
.	etc/server/machines.sh;
.	etc/server/ssh.sh;


################################################################################
##	definitions							      ##
################################################################################
ARGC=0;


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

function distribute_ssh_keys()
{
	for remote in ${all_machines}; do
		echo "	SSH	${remote}";
		sshpass -e \
		ssh -n ${ssh_opts} ${remote} "
			export SSHPASS='${SSHPASS}';
			/usr/local/src/server/libexec/ssh/distribute_key.sh;
			unset SSHPASS;
		";
	done
}

function secure_ssh()
{
	for remote in ${all_machines}; do
		echo "	SSH	${remote}";
		ssh -n ${remote} "
			echo '${SSHPASS}'				\\
			| sudo --stdin					\\
				/usr/local/src/server/libexec/ssh/secure_ssh.sh;
		";
	done
}


################################################################################
##	main								      ##
################################################################################
function main()
{
	read_ssh_password;
	/usr/local/src/server/libexec/ssh/gen_keys.sh;
	distribute_ssh_keys;
	secure_ssh;

	unset SSHPASS;
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
