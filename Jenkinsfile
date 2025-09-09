pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        APP_NAME = 'jenkins-cicd-node-project'
        BUILD_NUMBER_ENV = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '🔄 Fazendo checkout do código...'
                checkout scm
            }
        }
        
        stage('Setup Node.js') {
            steps {
                echo '⚙️ Configurando Node.js...'
                // Instalar Node.js se necessário
                sh '''
                    node --version || echo "Node.js não encontrado"
                    npm --version || echo "NPM não encontrado"
                '''
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo '📦 Instalando dependências...'
                sh 'npm ci'
            }
        }
        
        stage('Lint Code') {
            steps {
                echo '🔍 Executando lint...'
                sh 'npm run lint || echo "Lint não configurado, pulando..."'
            }
        }
        
        stage('Run Tests') {
            steps {
                echo '🧪 Executando testes...'
                sh 'npm test'
            }
            post {
                always {
                    // Publicar relatórios de teste
                    publishTestResults(
                        testResultsPattern: 'coverage/lcov.info',
                        allowEmptyResults: true
                    )
                    
                    // Arquivar relatórios de cobertura
                    publishHTML([
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'coverage',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }
        
        stage('Build') {
            steps {
                echo '🏗️ Executando build...'
                sh 'npm run build'
            }
        }
        
        stage('Security Scan') {
            steps {
                echo '🔒 Executando verificação de segurança...'
                sh '''
                    npm audit --audit-level=high || echo "Vulnerabilidades encontradas, mas continuando..."
                '''
            }
        }
        
        stage('Package') {
            steps {
                echo '📦 Criando pacote...'
                sh '''
                    tar -czf ${APP_NAME}-${BUILD_NUMBER_ENV}.tar.gz \
                        --exclude=node_modules \
                        --exclude=.git \
                        --exclude=coverage \
                        --exclude=*.tar.gz \
                        .
                '''
                
                archiveArtifacts(
                    artifacts: "${APP_NAME}-${BUILD_NUMBER_ENV}.tar.gz",
                    fingerprint: true
                )
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                echo '🚀 Deploy para ambiente de staging...'
                sh '''
                    echo "Simulando deploy para staging..."
                    echo "Artifact: ${APP_NAME}-${BUILD_NUMBER_ENV}.tar.gz"
                '''
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                echo '🎯 Deploy para produção...'
                input message: 'Confirmar deploy para produção?', ok: 'Deploy'
                sh '''
                    echo "Simulando deploy para produção..."
                    echo "Artifact: ${APP_NAME}-${BUILD_NUMBER_ENV}.tar.gz"
                '''
            }
        }
    }
    
    post {
        always {
            echo '🧹 Limpando workspace...'
            cleanWs()
        }
        
        success {
            echo '✅ Pipeline executado com sucesso!'
            // Aqui você pode adicionar notificações de sucesso
        }
        
        failure {
            echo '❌ Pipeline falhou!'
            // Aqui você pode adicionar notificações de falha
        }
        
        unstable {
            echo '⚠️ Pipeline instável!'
        }
    }
}
