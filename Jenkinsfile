pipeline {
  agent {
    docker {
      image 'atrng/py_agent:0.0.1'
    }

  }
  environment {
    // env variables for tox
    PYENV_ROOT = "${env.HOME}/.pyenv"
    PATH = "${env.PYENV_ROOT}/bin:${env.PATH}"
  }
  stages {
    stage('Install Style-Doc-Deps') {
        steps {
            sh 'make install-style-doc-deps'
        }
    }
    stage('Code Style') {
          steps {
            sh 'make lint'
          }
      }

    stage('Test') {
          steps {
            sh 'make test'
          }
    }
  }
}