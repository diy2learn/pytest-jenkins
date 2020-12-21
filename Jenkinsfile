pipeline {
  agent {
    docker {
      image 'atrng/py_agent:0.0.1'
    }

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

    stage('Test') {
      steps {
        sh 'make test'
      }
    }


    }

  }
}