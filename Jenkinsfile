pipeline {
  agent {
    docker {
      image 'kruschecompany/base-jdk8-postgres-nodejs'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh 'sudo service postgresql start'
        sh 'ps axu'
      }
    }
    stage('build third parties') {
      steps {
        sh 'echo \'Hello\''
      }
    }
  }
}