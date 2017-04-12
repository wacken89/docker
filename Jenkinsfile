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
        sh 'nohup sudo /usr/bin/Xvfb :99 -screen 1 1280x1024x16 -nolisten tcp -fbdir /var/run &'
        sh 'nohup sudo /usr/bin/Xvfb :98 -screen 2 1280x1024x16 -nolisten tcp -fbdir /var/run &'
      }
    }
    stage('build third parties') {
      steps {
        sh 'ps axu| grep Xvfb'
      }
    }
  }
}