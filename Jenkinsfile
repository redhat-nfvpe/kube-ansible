pipeline {
    agent {
        label 'jenkins-agent-ansible-274-centos7'
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
                sh "ansible-playbook -c local -i inventory/ci/virthost2.home.61will.space/engine.yml playbooks/ovirt_vm_infra.yml -e 'vm_state=running'"
            }
        }

        stage('Install Kubernetes') {
            steps {
                sh "mkdir -p .ssh && chmod 0700 .ssh"
                configFileProvider([configFile(fileId: 'kube-ansible-ssh-privkey', targetLocation: '.ssh/id_rsa')]) {}
                sh "chmod 0400 .ssh/id_rsa"
                sh "ansible-playbook -i inventory/ci/virthost2.home.61will.space/vms.local playbooks/kube-install.yml"
            }
        }
    }
    post {
        always {
            sh "ansible-playbook -c local -i inventory/ci/virthost2.home.61will.space/engine.yml playbooks/ovirt_vm_infra.yml -e 'vm_state=absent'"
        }
    }
}

// vim: ft=groovy shiftwidth=4 tabstop=4 expandtab smartindent :
