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
                sh 'ansible-playbook -i ${env.PWD}/ansible/inventory/engine.yml ${env.PWD}/ansible/playbooks/virtual_machines.yml -e "vm_state=absent"'
                sh 'ansible-playbook -i ${env.PWD}/ansible/inventory/engine.yml ${env.PWD}/ansible/playbooks/virtual_machines.yml -e "vm_state=running"'
            }
        }
    }
}
