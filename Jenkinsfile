pipeline {
  agent {
    docker {
      image 'kruschecompany/base-jdk8-postgres-nodejs'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        parallel(
          "Build": {
            sh 'ls'
            
          },
          "": {
            echo 'hello'
            
          }
        )
      }
    }
    stage('build third parties') {
      steps {
        sh 'echo \'Hello\''
      }
    }
  }
}