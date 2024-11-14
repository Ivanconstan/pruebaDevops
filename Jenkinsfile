pipeline {
    agent any
    stages {
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Generate Ansible and Robot Files') {
            steps {
                sh './generar_archivos.sh'
            }
        }
        stage('Ansible Provisioning') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i hosts.ini nginx_playbook.yml'
                }
            }
        }
        stage('Run Robot Framework Test') {
            steps {
                dir('tests') {
                    sh 'robot test_robotnginx.robot'
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'tests/*.xml', allowEmptyArchive: true
        }
    }
}
