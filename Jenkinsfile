pipeline {
  agent {
    docker {
      image 'kruschecompany/base-jdk8-postgres-nodejs'
    }
    
  }
  stages {
    stage('starting project') {
      steps {
        sh 'echo "Hello World"'
      }
    }
  }
}