help:
	@echo 'Available make services:'
	@echo 'docker-build-jenkins'
	@echo 'docker-build-xenial'
	@echo 'jenkins-run'

docker-build-jenkins:
	docker build -t jenkins-docker-image -f JenkinsDockerfile .

docker-build-xenial:
	docker build -t xenial-docker-image -f XenialDockerfile .

jenkins-run:
	docker run -d -p 8080:8080 --name jenkins-docker-container -v /var/run/docker.sock:/var/run/docker.sock jenkins-docker-image

#-------Jenkins CICD ---------------#
install-style-doc-deps:
	python -m pip install .[lint,doc]

lint:
	flake8 .

test:
	python setup.py test
	# tox

clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	find . -name __pycache__ -delete