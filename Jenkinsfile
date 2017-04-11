pipeline {
  agent {
    docker {
      image 'postgres'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        parallel(
          "Build": {
            sh 'ls'
            sh 'apt-get update'
            sh 'apt-get install java-jdk8'
            
          },
          "second build": {
            echo 'hello'
            sh 'env'
            
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
  environment {
    POSTGRES_USER = 'go'
    POSTGRES_DB = 'go'
  }
}