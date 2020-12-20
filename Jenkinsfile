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
    stage('build') {
      steps {
        sh 'pip install --no-cache-dir -r requirements.txt'
      }
    }

    stage('test') {
      steps {
        sh 'pytest'
      }
    }

  }
}