#!/bin/bash -x
##	sudo ./bin/install_basic.sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Install network and ssh server
## ==============================
##
################################################################################


################################################################################
##	source								      ##
################################################################################
source	lib/libalx/sh/sysexits.sh;

source	lib/server/network/etc.sh;
source	lib/server/ssh/install.sh;


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

	apt-get update;
	apt-get upgrade --yes;
	copy_etc;
	install_ssh;
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
