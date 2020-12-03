#!/bin/bash
set -Eeo pipefail
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################


################################################################################
##	source								      ##
################################################################################
.	/usr/local/src/server/lib/libalx/sh/sysexits.sh;
.	/usr/locar/src/server/etc/server/ssh.sh;


################################################################################
##	definitions							      ##
################################################################################
ARGC=0;


################################################################################
##	functions							      ##
################################################################################
function sshd_config__x()
{
	local	config="$1";
	local	val="$2";

	echo "	${config}	${val}";
	sed -i	"/^[ \t#]*${config}/s/^.*$/${config} ${val}/"		\
		/etc/ssh/sshd_config;
	grep -q	"^${config} ${val}$" /etc/ssh/sshd_config		\
	|| echo	"${config} ${val}" >> /etc/ssh/sshd_config;

}


################################################################################
##	main								      ##
################################################################################
function main()
{
	sshd_config__x	'PermitEmptyPasswords'		'no';
	sshd_config__x	'PermitRootLogin'		'no';
	sshd_config__x	'PasswordAuthentication'	'no';
	sshd_config__x	'AllowUsers'			"${ssh_allow_users}";
	sshd_config__x	'PublicKeyAuthentication'	'yes';
	sshd_config__x	'Port'				"${ssh_port}";
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
