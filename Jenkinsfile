pipeline {
  agent any

  stages {
    stage('Terraform Apply') {
      steps {
        sh 'terraform init -no-color'
        sh 'terraform apply -auto-approve -no-color'
      }
    }

    stage('Ansible Provisioning') {
      steps {
        sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
      }
    }
  }
}

