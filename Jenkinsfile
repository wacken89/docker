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
        sh '''sudo su - postgres -c "psql << EOF
create user $POSTGRES_USER;
alter user $POSTGRES_USER;
EOF
"'''
      }
    }
    stage('build third parties') {
      steps {
        sh 'ps axu| grep Xvfb'
      }
    }
  }
  environment {
    POSTGRES_USER = 'jenkins'
  }
}