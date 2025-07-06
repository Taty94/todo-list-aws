pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        STAGE = 'production'
        GITHUB_TOKEN = credentials('github-token')
    }
    stages {
        stage ('Get Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Taty94/todo-list-aws'
                sh 'ls -la'
                echo WORKSPACE
            }
        }
        stage('SetUp'){
            steps{
                echo 'Setup Virtualenv for production'
                sh "bash myownresources/common/setup.sh"
            }
        }

        stage('Deploy') {
          steps {
                sh 'bash myownresources/common/build.sh'
                sh 'bash myownresources/common/deploy.sh'
          }
        }
        stage('Integration Test'){
            steps{
                script {
                    def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name todo-list-aws-production --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",
                        returnStdout: true).trim()
                    echo "$BASE_URL"
                    echo 'Initiating Integration Tests'
                    sh "bash myownresources/production/integration.sh $BASE_URL"
                }
            }
        }
    }
    post { 
        always { 
            echo 'Clean env: delete dir'
            cleanWs()
        }
    }
}