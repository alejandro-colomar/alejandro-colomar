#!/bin/bash
set -Eeuo pipefail;
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################


################################################################################
##	source								      ##
################################################################################


################################################################################
##	definitions							      ##
################################################################################
EX_USAGE=64;
ARGC=0;

DK_IMG='debian:testing';


################################################################################
##	functions							      ##
################################################################################


################################################################################
##	main								      ##
################################################################################
function main()
{
	local	date=$(date +%F-%H-%M-%S);
	local	dk_cont="test_${date}";

	echo "	DOCKER	run --name ${dk_cont}";
	docker run -dt --name ${dk_cont} ${DK_IMG};

	echo '	APT-GET	update';
	docker exec ${dk_cont} apt-get update;

	echo '	INSTALL	ssh';
	docker exec ${dk_cont}						\
		apt-get install -y --no-install-recommends openssh-server;

	echo '	CP	sshd_config';
	docker cp etc/ssh/sshd_config ${dk_cont}:/etc/ssh;

	echo '	RESTART	ssh';
	docker exec ${dk_cont} service ssh restart;

	echo '	TEST	ssh status';
	docker exec ${dk_cont} service ssh status | grep 'sshd is running';

	echo '	DOCKER	rm';
	docker rm -f ${dk_cont};
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
