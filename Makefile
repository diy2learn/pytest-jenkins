docker-build-jenkins:
	docker build -t jenkins-docker-image -f JenkinsDockerfile .

docker-build-xenial:
	docker build -t xenial-docker-image -f XenialDockerfile .