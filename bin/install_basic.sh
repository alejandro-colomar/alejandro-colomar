#!/bin/bash
set -Eeo pipefail;
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
EX_USAGE=64;


################################################################################
##	definitions							      ##
################################################################################
ARGC=0;

user="ubuntu";


################################################################################
##	functions							      ##
################################################################################


################################################################################
##	main								      ##
################################################################################
function main()
{

	apt-get update;
	apt-get upgrade --yes --verbose-versions;
	apt-get install --yes --verbose-versions --no-install-recommends\
		ca-certificates						\
		git							\
		make							\
		openssh-server						\
		sshpass;
	chown -R ${user}:${user} /usr/local/src;
	git clone							\
		https://github.com/alejandro-colomar/libalx.git		\
		/usr/local/src/libalx;
	git clone							\
		https://github.com/alejandro-colomar/server.git		\
		/usr/local/src/server;
	cp --remove-destination -vT					\
		/usr/local/src/server/etc/hosts				\
		/etc/hosts;
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
