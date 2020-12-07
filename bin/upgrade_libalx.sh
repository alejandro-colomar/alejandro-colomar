#!/bin/bash
set -Eeo pipefail;
##	./bin/install_libalx.sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## (Re)Install libalx
## ==================
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

function install_libalx()
{
	local	repo='/usr/local/src/libalx';

	for remote in ${all_machines}; do
		echo "	SSH	${remote}";
		ssh -n ${remote} "
			echo '${SUDOPASS}'				\\
			| sudo --stdin					\\
				make uninstall -C '${repo}';
			echo '${SUDOPASS}'				\\
			| sudo --stdin					\\
				make install-libexec install-sh -C '${repo}';
		";
	done
}



################################################################################
##	main								      ##
################################################################################
function main()
{
	read_ssh_password;
	install_libalx;
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
