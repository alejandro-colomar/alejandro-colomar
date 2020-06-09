##	source	./etc/docker-aws/config.sh
###############################################################################
##       Copyright (C) 2020        Sebastian Francisco Colomar Bauza         ##
##       Copyright (C) 2020        Alejandro Colomar Andrés                  ##
##       SPDX-License-Identifier:  GPL-2.0-only                              ##
###############################################################################
##
## The template for this file is in:
## https://github.com/secobau/docker-aws/share/templates/deploy_aws.template.sh
##
## Read it to learn how to configure it.
##


################################################################################
##	variables							      ##
################################################################################
branch_docker_aws="v4.3"
debug=true
domain="raw.githubusercontent.com"
HostedZoneName="alejandro-colomar.es"
mode="swarm"
repository_docker_aws="docker-aws"
stack="alejandro-colomar"
username_docker_aws="secobau"
########################################
A="${username_docker_aws}/${repository_docker_aws}/${branch_docker_aws}"
########################################
## Identifier is the ID of the certificate in case you are using HTTPS
Identifier="8245427e-fbfa-4f2b-b23f-97f13d6d3e7c"
KeyName="proxy2aws"
RecordSetName1="www"
RecordSetName2="service-2"
RecordSetName3="service-3"
RecordSetNameKube="service-kube"
s3name="docker-aws"
s3region="ap-south-1"
template="https.yaml"
TypeManager="t3a.nano"
TypeWorker="t3a.nano"
########################################
apps=" docker-compose_amd64.yaml "
branch_app="master"
repository_app="alejandro-colomar"
username_app="alejandro-colomar"


################################################################################
##	export								      ##
################################################################################
export branch_docker_aws
export debug
export domain
export HostedZoneName
export mode
export repository_docker_aws
export stack
export username_docker_aws
########################################
export A
########################################
export Identifier
export KeyName
export RecordSetName1
export RecordSetName2
export RecordSetName3
export RecordSetNameKube
export s3name
export s3region
export template
export TypeManager
export TypeWorker
########################################
export apps
export branch_app
export repository_app
export username_app


################################################################################
##	end of file							      ##
################################################################################
