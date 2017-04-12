pipeline {
  agent {
    docker {
      image 'kruschecompany/base-jdk8-postgres-nodejs'
    }
    
  }
  stages {
    stage('Git & Preparing') {
      steps {
        sh 'sudo service postgresql start'
        sh '''sudo su - postgres -c "psql << EOF
create user $POSTGRES_USER;
alter user $POSTGRES_USER superuser;
EOF
"'''
      }
    }
    stage('Build') {
      steps {
        sh 'psql --dbname=postgres < create-db.sql'
        sh '''nohup sudo /usr/bin/Xvfb :99 -screen 1 1280x1024x16 -nolisten tcp -fbdir /var/run > /dev/null 2>&1 &
nohup sudo /usr/bin/Xvfb :98 -screen 2 1280x1024x16 -nolisten tcp -fbdir /var/run > /dev/null 2>&1 &
nohup sudo /usr/bin/Xvfb :97 -screen 3 1280x1024x16 -nolisten tcp -fbdir /var/run > /dev/null 2>&1 &'''
        sh './gradlew --no-daemon -g ${SNAP_CACHE_DIR}/.gradle fullCheck packageApp'
      }
    }
  }
  environment {
    POSTGRES_USER = 'jenkins'
  }
}