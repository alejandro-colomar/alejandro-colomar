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
	local	log="tmp/test_${date}.log";

	echo "	LOG	${log}";
	mkdir -p $(dirname ${log});

	echo "	DOCKER	run --name ${dk_cont}";
	docker run -dt --name ${dk_cont} ${DK_IMG} 1>>${log};

	echo '	CP	install_basic.sh';
	docker cp ./bin/install_basic.sh ${dk_cont}:./bin 1>>${log};

	echo '	ADAPT	install_basic.sh';
	docker exec ${dk_cont}						\
		sed -i -e '/^user=/s/=.*/="root";/'			\
		-e '/cp --remove-destination/,/\/etc\/hosts;/d'		\
		./bin/install_basic.sh 1>>${log};

	echo '	RUN	install_basic.sh';
	docker exec ${dk_cont} ./bin/install_basic.sh 1>>${log};

	echo '	RUN	libexec/ssh/secure_ssh.sh';
	docker exec ${dk_cont} /usr/local/src/server/libexec/ssh/secure_ssh.sh 1>>${log};

	echo '	TEST	ssh status';
	docker exec ${dk_cont} service ssh status | grep 'sshd is running' 1>>${log};

	echo '	DOCKER	rm';
	docker rm -f ${dk_cont} 1>>${log};

	echo '	OK';
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
