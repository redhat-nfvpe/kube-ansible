pipeline {
    agent {
        label 'kube-ansible'
    }

    environment {
        ENGINE_CREDS = credentials('engine-management-creds')
        VM_SSH_KEY = credentials('ka-public-ssh-key')
    }

    stages {
        stage('Environment setup and prerequisites') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                sh 'ansible-galaxy install -r requirements.yml'
            }
        }

        stage('Build virtual machines') {
            steps {
                sh "ansible-playbook -i inventory/ci/virthost2.home.61will.space/engine.yml playbooks/ovirt_vm_infra.yml -e 'vm_state=running'"
            }
        }
    }
    post {
        always {
            sh "ansible-playbook -i inventory/ci/virthost2.home.61will.space/engine.yml playbooks/ovirt_vm_infra.yml -e 'vm_state=absent'"
        }
    }
}

// vim: ft=groovy shiftwidth=4 tabstop=4 expandtab smartindent :
