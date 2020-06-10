##	source	./etc/docker-aws/config.sh
################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## The template for this file is in:
## https://github.com/secobau/docker-aws/share/templates/deploy_aws.template.sh
##
## Read it to learn how to configure it.
##
################################################################################


################################################################################
##	definitions							      ##
################################################################################
export	branch_docker_aws="v4.3"
export	debug=true
export	domain="raw.githubusercontent.com"
export	HostedZoneName="alejandro-colomar.es"
export	mode="swarm"
export	repository_docker_aws="docker-aws"
export	stack="alejandro-colomar"
export	username_docker_aws="secobau"
########################################
export	A="${username_docker_aws}/${repository_docker_aws}/${branch_docker_aws}"
########################################
## Identifier is the ID of the certificate in case you are using HTTPS
export	Identifier="8245427e-fbfa-4f2b-b23f-97f13d6d3e7c"
export	KeyName="proxy2aws"
export	RecordSetName1="www"
export	RecordSetName2="service-2"
export	RecordSetName3="service-3"
export	RecordSetNameKube="service-kube"
export	s3name="docker-aws"
export	s3region="ap-south-1"
export	template="https.yaml"
export	TypeManager="t3a.nano"
export	TypeWorker="t3a.nano"
########################################
export	apps=" docker-compose.yaml "
export	branch_app="master"
export	repository_app="alejandro-colomar"
export	username_app="alejandro-colomar"


################################################################################
##	end of file							      ##
################################################################################
