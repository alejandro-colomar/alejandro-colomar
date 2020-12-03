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
.	/usr/local/src/server/etc/server/ssh.sh;


################################################################################
##	definitions							      ##
################################################################################
ARGC=0;


################################################################################
##	functions							      ##
################################################################################
function sshd_config()
{
	local	key="$1";
	local	val="$2";
	local	file="/etc/ssh/sshd_config";

	echo "	SSHD	config";
	/usr/local/libexec/libalx/config_file.sh "${key}" "${val}" "${file}";

}


################################################################################
##	main								      ##
################################################################################
function main()
{
	sshd_config	'PermitEmptyPasswords'		'no';
	sshd_config	'PermitRootLogin'		'no';
	sshd_config	'PasswordAuthentication'	'no';
	sshd_config	'AllowUsers'			"${ssh_allow_users}";
	sshd_config	'PubkeyAuthentication'		'yes';
	systemctl restart sshd;
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
