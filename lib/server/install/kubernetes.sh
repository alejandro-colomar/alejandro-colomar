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
function kube_prepare_https__()
{

	apt-get update							&& \
	apt-get install -y						\
			apt-transport-https				\
			ca-certificates					\
			curl						\
			gnupg2;
}

function kube_add_kube_gpg_key__()
{

	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
		| apt-key add -;
}

function kube_add_kube_repository__()
{

	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main"	\
		| sudo tee -a /etc/apt/sources.list.d/kubernetes.list;
}

function kube_set_up_repository__()
{

	kube_prepare_https__						&& \
	kube_add_kube_gpg_key__						&& \
	kube_add_kube_repository__;
}

function kube_install_kubernetes__()
{

	apt-get update							&& \
	apt-get install -y						\
			kubeadm						\
			kubectl						\
			kubelet;
}

function install_kubernetes()
{

	kube_set_up_repository__					&& \
	kube_install_kubernetes__;
}


################################################################################
##	end of file							      ##
################################################################################
