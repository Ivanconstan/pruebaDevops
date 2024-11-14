pipeline {
    agent any
    stages {
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
