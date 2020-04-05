pipeline {
  agent {
    docker {
      image 'python:3.6-slim'
    }

  }
  stages {
    stage('build') {
      steps {
        sh 'pip install --no-cache-dir -r requirements.txt'
      }
    }

  }
}