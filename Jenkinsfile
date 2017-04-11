pipeline {
  agent {
    docker {
      image 'postgres'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh '''env
uname -a'''
        sh 'sudo apt-get update'
        sh 'sudo apt-get install -y java-jdk8 mc'
      }
    }
    stage('build third parties') {
      steps {
        sh 'echo \'Hello\''
      }
    }
  }
  environment {
    POSTGRES_USER = 'go'
    POSTGRES_DB = 'go'
  }
}