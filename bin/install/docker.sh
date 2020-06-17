#!/bin/bash -x
##	./bin/install/docker.sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Install docker
## ==============
##
################################################################################


################################################################################
##	source								      ##
################################################################################
source	lib/libalx/sh/sysexits.sh;


################################################################################
##	definitions							      ##
################################################################################
ARGC=0;


################################################################################
##	functions							      ##
################################################################################
function uninstall_old_versions()
{

	apt-get purge -y						\
			docker						\
			docker-engine					\
			docker.io					\
			containerd					\
			runc;
}

function prepare_https()
{

	apt-get update							&& \
	apt-get install -y						\
			apt-transport-https				\
			ca-certificates					\
			curl						\
			gnupg-agent					\
			software-properties-common;
}

function add_docker_gpg_key()
{

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg |apt-key add - && \
	apt-key fingerprint 0EBFCD88;
}

function add_docker_repository()
{

	add-apt-repository						\
			"deb https://download.docker.com/linux/ubuntu	\
			$(lsb_release -cs)				\
			stable";
}

function set_up_repository()
{

	prepare_https							&& \
	add_docker_gpg_key						&& \
	add_docker_repository;
}

function install_docker_engine()
{

	apt-get update							&& \
	apt-get install -y						\
			docker-ce					\
			docker-ce-cli					\
			containerd.io					&& \
	## Test the installation
	docker run --rm hello-world;
}

function add_user_to_docker_group()
{

	usermod -a -G docker ubuntu;
}


################################################################################
##	main								      ##
################################################################################
function main()
{

	uninstall_old_versions;
	set_up_repository						&& \
	install_docker_engine						&& \
	add_user_to_docker_group;
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
