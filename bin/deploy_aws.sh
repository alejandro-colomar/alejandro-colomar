#!/bin/bash -x
##	./bin/deploy_aws.sh
################################################################################
##       Copyright (C) 2020        Sebastian Francisco Colomar Bauza          ##
##       Copyright (C) 2020        Alejandro Colomar Andrés                   ##
##       SPDX-License-Identifier:  GPL-2.0-only                               ##
################################################################################
##
## The template for this file is in:
## https://github.com/secobau/docker-aws/share/templates/deploy_aws.template.sh
##
## Read it to learn how to configure it.
##
################################################################################


################################################################################
##	source								      ##
################################################################################
source	lib/libalx/sh/sysexits.sh

source	etc/docker-aws/config.sh


################################################################################
##	definitions							      ##
################################################################################
ARGC=0


################################################################################
##	functions							      ##
################################################################################
function create_new_dir()
{
	local	path="$HOME/.${repository_app}/var"
	local	dname="$( date +%F_%H%M )"

	mkdir	--parents ${path}/${dname}
	cd	${path}/${dname}
}

function get_init_script()
{
	local	fpath="${A}/bin"
	local	fname="$1"

	curl	--output ${fname} https://${domain}/${fpath}/${fname}?$( uuidgen )
	chmod	+x ./${fname}
}


################################################################################
##	main								      ##
################################################################################
function main()
{
	local	fname="init.sh"

	create_new_dir
	get_init_script	${fname}

	nohup ./${fname} &
}


################################################################################
##	run								      ##
################################################################################
argc=$#
if [ ${argc} -ne ${ARGC} ]; then
	echo	"Illegal number of parameters (Requires ${ARGC})"
	exit	${EX_USAGE}
fi

main


################################################################################
##	end of file							      ##
################################################################################
