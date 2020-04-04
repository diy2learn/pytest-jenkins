help:
	@echo 'Available make services:'
	@echo 'docker-build-jenkins'
	@echo 'docker-build-xenial'

docker-build-jenkins:
	docker build -t jenkins-docker-image -f JenkinsDockerfile .

docker-build-xenial:
	docker build -t xenial-docker-image -f XenialDockerfile .