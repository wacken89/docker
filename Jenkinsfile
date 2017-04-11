pipeline {
  agent {
    docker {
      image 'kruschecompany/base-jdk8-postgres-nodejs'
    }
    
  }
  stages {
    stage('') {
      steps {
        parallel(
          "Show ENV": {
            sh 'env'
            
          },
          "Say Hi": {
            sh 'echo \'Hello World\''
            
          },
          "Something": {
            echo 'That\'s all'
            
          }
        )
      }
    }
  }
}