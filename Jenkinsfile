pipeline {
  agent {
    docker {
      image 'kruschecompany/base-jdk8-postgres-nodejs'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh 'cat /etc/sudoers'
      }
    }
    stage('build third parties') {
      steps {
        sh 'echo \'Hello\''
      }
    }
  }
}