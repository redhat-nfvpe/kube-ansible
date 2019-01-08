pipeline {
    agent {
        label 'jenkins-agent-ansible-274-centos7'
    }

    environment {
        ENGINE_CREDS = credentials('engine-management-creds')
        VM_SSH_KEY = credentials('ka-public-ssh-key')
        ANSIBLE_SSH_PASS = credentials('ka-ansible-ssh-pass')
    }

    stages {
        stage('Environment setup and prerequisites') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                sh 'ansible-galaxy install -r requirements.yml'
                sh "ansible-playbook -c local -i inventory/ci/virthost2.home.61will.space/engine.yml playbooks/ovirt_vm_infra.yml -e 'vm_state=absent'"
            }
        }

        stage('Build virtual machines') {
            steps {
                sh "ansible-playbook -c local -i inventory/ci/virthost2.home.61will.space/engine.yml playbooks/ovirt_vm_infra.yml -e 'vm_state=running'"
            }
        }

        stage('Install Kubernetes') {
            steps {
                sh "mkdir -p /home/jenkins/.ssh && chmod 0700 /home/jenkins/.ssh"
                // for now we're copying the keys over, but they are not used because I can't get the container image to ssh via keys into the virtual machines
                configFileProvider([configFile(fileId: 'kube-ansible-ssh-privkey', targetLocation: '/home/jenkins/.ssh/id_rsa')]) {}
                configFileProvider([configFile(fileId: 'kube-ansible-ssh-pubkey', targetLocation: '/home/jenkins/.ssh/id_rsa.pub')]) {}
                sh "ansible-playbook -e ansible_ssh_pass=${env.ANSIBLE_SSH_PASS} -i inventory/ci/virthost2.home.61will.space/vms.local playbooks/kube-install.yml"
            }
        }
    }
    post {
        always {
            echo "All done."
        }
    }
}

// vim: ft=groovy shiftwidth=4 tabstop=4 expandtab smartindent :
