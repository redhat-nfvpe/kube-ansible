pipeline {
    agent {
        label 'kube-ansible'
    }

    stages {
        stage('Setup') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                sh 'pwd'
                sh 'ansible-galaxy install -r requirements.yml'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
