################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
##	source								      ##
################################################################################


################################################################################
##	definitions							      ##
################################################################################


################################################################################
##	functions							      ##
################################################################################
function dk_uninstall_old_versions__()
{

	apt-get purge -y						\
			docker						\
			docker-engine					\
			docker.io					\
			containerd					\
			runc;
}

function dk_prepare_https__()
{

	apt-get update							&& \
	apt-get install -y						\
			apt-transport-https				\
			ca-certificates					\
			curl						\
			gnupg-agent					\
			software-properties-common;
}

function dk_add_docker_gpg_key__()
{

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg |apt-key add - && \
	apt-key fingerprint 0EBFCD88;
}

function dk_add_docker_repository__()
{

	add-apt-repository						\
			"deb https://download.docker.com/linux/ubuntu	\
			$(lsb_release -cs)				\
			stable";
}

function dk_set_up_repository__()
{

	dk_prepare_https__						&& \
	dk_add_docker_gpg_key__						&& \
	dk_add_docker_repository__;
}

function dk_install_docker_engine__()
{

	apt-get update							&& \
	apt-get install -y						\
			docker-ce					\
			docker-ce-cli					\
			containerd.io					&& \
	## Test the installation
	docker run --rm hello-world;
}

function dk_add_user_to_docker_group__()
{

	usermod -a -G docker ubuntu;
}

function install_docker()
{

	dk_uninstall_old_versions__;
	dk_set_up_repository__						&& \
	dk_install_docker_engine__					&& \
	dk_add_user_to_docker_group__;
}


################################################################################
##	end of file							      ##
################################################################################
