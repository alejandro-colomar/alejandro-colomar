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
	local	dk_cont="test_sshd_config_${date}";
	local	log="tmp/tests/sshd_config_${date}.log";

	echo "	LOG	${log}";
	mkdir -p $(dirname ${log});

	echo "	DOCKER	run --name ${dk_cont}" | tee -a ${log};
	docker run -dt --name ${dk_cont} ${DK_IMG} 1>>${log};

	echo '	APT-GET	update' | tee -a ${log};
	docker exec ${dk_cont} apt-get update 1>>${log};

	echo '	INSTALL	ssh' | tee -a ${log};
	docker exec ${dk_cont}						\
		apt-get install -y --no-install-recommends openssh-server 1>>${log};

	echo '	CP	sshd_config' | tee -a ${log};
	docker cp etc/ssh/sshd_config ${dk_cont}:/etc/ssh 1>>${log};

	echo '	RESTART	ssh' | tee -a ${log};
	docker exec ${dk_cont} service ssh restart 1>>${log};

	echo '	TEST	ssh status' | tee -a ${log};
	docker exec ${dk_cont} service ssh status | grep 'sshd is running' 1>>${log};

	echo '	DOCKER	rm' | tee -a ${log};
	docker rm -f ${dk_cont} 1>>${log};

	echo '	OK' | tee -a ${log};
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
