pipeline {
  agent {
    docker {
      image 'kruschecompany/base-jdk8-postgres-nodejs'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh '''echo "import pty; pty.spawn('/bin/bash')" > /tmp/asdf.py
python /tmp/asdf.py

su - root
sudo apt-get install mc
sudo service postgresql start'''
      }
    }
    stage('build third parties') {
      steps {
        sh 'echo \'Hello\''
      }
    }
  }
}