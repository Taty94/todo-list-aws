pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        STAGE = 'staging'
        GITHUB_TOKEN = credentials('github-token')
    }
    stages {
        stage ('Get Code') {
            steps {
                git branch: 'develop', url: 'https://github.com/Taty94/todo-list-aws'
                sh 'ls -la'
                echo WORKSPACE
            }
        }
        stage('SetUp'){
            steps{
                echo 'Setup Virtualenv for testing'
                sh "bash myownresources/common/setup.sh"
            }
        }
        stage('Static Test') {
            steps {
                echo 'Static program analysis:'
                sh "bash myownresources/staging/static_test.sh"
            }
            post {
                always {
                    recordIssues tools: [
                        flake8(pattern: 'flake8.out', name: 'Flake8'),
                        pyLint(pattern: 'bandit.out', name: 'Bandit')
                    ],
                    ignoreQualityGate: true
                }
            }
        }
        stage('Deploy') {
          steps {
              catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                sh 'bash myownresources/common/build.sh'
                sh 'bash myownresources/common/deploy.sh'
              }
          }
        }
        stage('Integration Test'){
            steps{
                script {
                    def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name todo-list-aws-staging --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",
                        returnStdout: true).trim()
                    echo "$BASE_URL"
                    echo 'Initiating Integration Tests'
                    sh "bash myownresources/staging/integration.sh $BASE_URL"
                }
            }
        }
        stage('Promote'){
            steps{
                echo 'Iniciando promoción a producción...'
                sh "bash myownresources/staging/mergeV2.sh"
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