#!/bin/bash
set -Eeo pipefail;
##	./bin/update_src.sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Update source code in all machines
## ==================================
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


################################################################################
##	main								      ##
################################################################################
function main()
{
	local	repo='/usr/local/src/libalx';

	for remote in ${all_machines}; do
		echo "	SSH	${remote}";
		ssh -n ${remote} "
			echo '	GIT	-C libalx	fetch -p';
			git -C ${repo} fetch -p -q;
			echo '	GIT	-C libalx	checkout origin/main';
			git -C ${repo} checkout origin/main;
		";
	done
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
