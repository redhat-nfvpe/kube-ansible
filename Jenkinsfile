pipeline {
    agent {
        label 'kube-ansible'
    }

    stages {
        stage('Setup') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                sh 'ansible-galaxy install -r requirements.yml'
            }
        }
        stage('Build virtual machines') {
            steps {
                env.ANSIBLE_HOME = '/home/jenkins/ansible'
                sh 'ansible-playbook -i ${env.ANSIBLE_HOME}/inventory/engine.yml ${env.ANSIBLE_HOME}/playbooks/virtual_machines.yml -e "vm_state=absent"'
                sh 'ansible-playbook -i ${env.ANSIBLE_HOME}/inventory/engine.yml ${env.ANSIBLE_HOME}/playbooks/virtual_machines.yml -e "vm_state=running"'
            }
        }
    }
}

// vim: ft=groovy shiftwidth=4 tabstop=4 expandtab smartindent :
