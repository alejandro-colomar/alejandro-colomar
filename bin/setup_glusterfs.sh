#!/bin/bash
set -Eeo pipefail
##	./bin/setup_glusterfs.sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Configure glusterfs network
## ===========================
##
##	Run this script from a guiX machine
##
################################################################################


################################################################################
##	source								      ##
################################################################################
.	lib/libalx/sh/sysexits.sh;
.	etc/server/machines.sh;


################################################################################
##	definitions							      ##
################################################################################
ARGC=0;


################################################################################
##	functions							      ##
################################################################################
## XXX: Pair calls to this function with "unset SUDOPASS;"!!!
function read_sudo_password()
{

	echo "Enter the password for sudo in remote machines."

	read -s -p "Password to use: " SUDOPASS;
	echo;
}

function setup_glusterfs()
{
	for remote in ${workers[*]}; do
		echo "	SSH	${remote}";
		ssh ${remote} "
			for peer in ${workers[*]}; do
				echo \"	PROBE	\${peer}\";
				echo '${SUDOPASS}'			\\
				| sudo --stdin				\\
					gluster peer probe \${peer};
			done
		";
	done

	echo "	POOL";
	ssh ${workers[0]} "
		echo '${SUDOPASS}'					\\
		| sudo --stdin						\\
			gluster pool list;
	";
}


################################################################################
##	main								      ##
################################################################################
function main()
{
	read_sudo_password;
	setup_glusterfs;
	unset SUDOPASS;
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
