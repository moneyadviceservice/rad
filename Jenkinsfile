pipeline {
    agent { label "master" }

    stages {
        stage('test') {
            steps {
                sh('./script/docker_compose')
            }
        }
    }
}
