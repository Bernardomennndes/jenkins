# Guia de Configuração do Jenkins

Este guia te ajudará a configurar o Jenkins para executar o pipeline CI/CD deste projeto.

## 🚨 Solução Rápida para "This page may not exist, or you may not have permission to see it"

Se você está vendo essa mensagem, siga estes passos:

1. **Aguarde a inicialização completa** (2-3 minutos após iniciar o Jenkins)

2. **Verifique se o Jenkins está rodando:**
   ```bash
   # Para Docker
   docker ps | grep jenkins
   
   # Para instalação local
   brew services list | grep jenkins
   ```

3. **Acesse a URL correta:**
   - Use: `http://localhost:8080` (sem https)
   - Limpe o cache do navegador (Cmd+Shift+R no Mac)

4. **Se ainda não funcionar, reinicie o Jenkins:**
   ```bash
   # Para Docker
   docker-compose down
   docker-compose up jenkins
   
   # Para instalação local
   brew services restart jenkins-lts
   ```

5. **Aguarde aparecer a tela "Unlock Jenkins"** e continue com a configuração inicial abaixo.

## 🔧 Instalação do Jenkins

### Opção 1: Docker (Recomendado)

```bash
# Usando o docker-compose incluso no projeto
docker-compose up jenkins

# Ou usando Docker diretamente
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

### Opção 2: Instalação Local (macOS)

```bash
# Usando Homebrew
brew install jenkins-lts

# Iniciar Jenkins
brew services start jenkins-lts
```

## ⚙️ Configuração Inicial

1. **Acesse o Jenkins**: `http://localhost:8080`

2. **Aguarde a inicialização completa** (pode levar 2-3 minutos)

3. **Tela "Unlock Jenkins"** - Obtenha a senha inicial:
   ```bash
   # Para Docker
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   
   # Para instalação local
   cat ~/.jenkins/secrets/initialAdminPassword
   ```

4. **Configuração de Plugins:**
   - Escolha "Install suggested plugins" (recomendado)
   - Ou selecione plugins manualmente:
     - Git
     - NodeJS
     - Pipeline
     - HTML Publisher
     - Test Results Analyzer
     - Workspace Cleanup

5. **Criar usuário administrador:**
   - Preencha os dados do primeiro usuário
   - **Importante**: Anote usuário e senha!

6. **Configuração da instância:**
   - Mantenha a URL padrão: `http://localhost:8080/`
   - Clique em "Save and Finish"

7. **Verificar dashboard:**
   - Você deve ver a mensagem "Welcome to Jenkins!"
   - O menu lateral deve mostrar opções como "New Item"

## 📋 Configuração do Pipeline

### Passo 1: Criar um Novo Job

**Para Jenkins 2.516.2:**

1. Na página inicial do Jenkins, procure por uma das seguintes opções:
   - **"+ New Item"** (no menu lateral esquerdo)
   - **"Create a job"** (no centro da página)
   - **"New Item"** (no menu superior)

2. Se não encontrar essas opções:
   - Clique em **"Dashboard"** no canto superior esquerdo
   - Procure por **"Create a job"** na área central
   - Ou use a URL direta: `http://localhost:8080/view/all/newJob`

3. Na tela de criação:
   - **Enter an item name**: Digite `node-cicd-pipeline`
   - Selecione **"Pipeline"** na lista de tipos
   - Clique em **"OK"**

### Passo 2: Configurar o SCM

**Método 1 - Interface Clássica:**

Na seção **Pipeline**:

1. **Definition**: Pipeline script from SCM
2. **SCM**: Git
3. **Repository URL**: URL do seu repositório Git
4. **Branch Specifier**: `*/main` (ou a branch principal)
5. **Script Path**: `Jenkinsfile`

**Método 2 - Interface Moderna (Blue Ocean):**

1. Após criar o pipeline, clique em **"Configure"**
2. Na seção **"Pipeline"**:
   - **Definition**: Escolha "Pipeline script from SCM"
   - **SCM**: Selecione "Git"
   - **Repository URL**: Cole a URL do seu repositório
   - **Credentials**: Adicione se necessário (repositório privado)
   - **Branches to build**: `*/main`
   - **Script Path**: `Jenkinsfile`
3. Clique em **"Save"**

**Método 3 - Via Blue Ocean (se disponível):**

1. Clique em **"Open Blue Ocean"** no menu lateral
2. Clique em **"Create a new Pipeline"**
3. Selecione onde está seu código (GitHub, Bitbucket, Git)
4. Siga o assistente para conectar seu repositório

### Passo 3: Configurar Node.js

1. Vá em "Manage Jenkins" > "Global Tool Configuration"
2. Na seção **NodeJS**:
   - Clique em "Add NodeJS"
   - Nome: `Node18`
   - Versão: `18.x` (mais recente)
   - Marque "Install automatically"

### Passo 4: Configurar Webhooks (Opcional)

Para execução automática do pipeline:

1. No GitHub/GitLab, vá em Settings > Webhooks
2. URL: `http://seu-jenkins:8080/github-webhook/`
3. Content type: `application/json`
4. Eventos: `Push`, `Pull Request`

## 🎯 Configurações Avançadas

### Notificações por Email

1. Vá em "Manage Jenkins" > "Configure System"
2. Configure SMTP na seção **E-mail Notification**
3. Adicione no Jenkinsfile:
   ```groovy
   post {
       failure {
           emailext (
               subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
               body: "Build failed. Check console output at ${env.BUILD_URL}",
               to: "seu-email@example.com"
           )
       }
   }
   ```

### Integração com Slack

1. Instale o plugin "Slack Notification"
2. Configure o webhook do Slack
3. Adicione no Jenkinsfile:
   ```groovy
   post {
       success {
           slackSend channel: '#builds',
                    message: "✅ Build successful: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
       }
   }
   ```

### Configuração de Agentes

Para executar builds em paralelo:

1. Vá em "Manage Jenkins" > "Manage Nodes and Clouds"
2. Adicione novos agentes conforme necessário
3. No Jenkinsfile, use:
   ```groovy
   agent {
       label 'linux'  // ou outro label
   }
   ```

## 🔒 Segurança

### Configurar Credenciais

1. Vá em "Manage Jenkins" > "Manage Credentials"
2. Adicione credenciais para:
   - Repositório Git (se privado)
   - Docker Registry
   - Serviços de deploy

### Configurar Permissões

1. Vá em "Manage Jenkins" > "Configure Global Security"
2. Configure authentication (LDAP, GitHub, etc.)
3. Configure authorization baseada em matriz

## 📊 Monitoramento

### Plugins Úteis para Monitoramento

- **Blue Ocean**: Interface moderna para pipelines
- **Pipeline Stage View**: Visualização de etapas
- **Build Monitor**: Dashboard de builds
- **Prometheus**: Métricas para monitoramento

### Dashboards

1. Instale o plugin "Dashboard View"
2. Crie dashboards personalizados
3. Configure widgets para:
   - Status dos builds
   - Tempo de execução
   - Taxa de sucesso

## 🚀 Executando o Pipeline

### Primeira Execução

1. Vá para o job criado
2. Clique em "Build Now"
3. Acompanhe o progresso na aba "Console Output"

### Execução Automática

O pipeline será executado automaticamente quando:
- Código for enviado para o repositório (se webhooks configurados)
- Pull requests forem criados
- Em horários agendados (se configurado)

## 🐛 Troubleshooting

### Interface do Jenkins 2.516.2

**Não consegue encontrar "New Item" ou "Create Job"?**

1. **Verifique se você está logado** como administrador
2. **Tente estas alternativas**:
   - URL direta: `http://localhost:8080/view/all/newJob`
   - Menu "Dashboard" → área central da página
   - Clicar no ícone "+" se disponível
   - Menu "Manage Jenkins" → "Create Job" (em algumas configurações)

3. **Se ainda não aparecer**:
   ```bash
   # Reinicie o Jenkins
   docker restart jenkins
   # ou para instalação local
   brew services restart jenkins-lts
   ```

4. **Verificar permissões**:
   - Vá em "Manage Jenkins" → "Configure Global Security"
   - Certifique-se de que seu usuário tem permissão "Job/Create"

**Interface diferente?**
- O Jenkins 2.516.2 pode ter a interface "Blue Ocean" ativada
- Para usar a interface clássica: `http://localhost:8080/view/all/`
- Para desabilitar Blue Ocean: "Manage Jenkins" → "Manage Plugins" → desativar "Blue Ocean"

### Problemas Comuns

## 🐛 Troubleshooting

### Problemas Comuns

**"This page may not exist, or you may not have permission to see it":**

1. **Verificar se Jenkins iniciou corretamente:**
   ```bash
   # Para Docker
   docker logs jenkins
   
   # Para instalação local
   brew services list | grep jenkins
   ```

2. **Acessar com a URL correta:**
   - Use: `http://localhost:8080` (não https)
   - Aguarde alguns minutos após iniciar o Jenkins

3. **Resetar configuração inicial:**
   ```bash
   # Para Docker - reiniciar container
   docker-compose down && docker-compose up jenkins
   
   # Para instalação local - reiniciar serviço
   brew services restart jenkins-lts
   ```

4. **Verificar logs de inicialização:**
   ```bash
   # Docker
   docker logs jenkins | grep "initialAdminPassword"
   
   # Local
   tail -f ~/.jenkins/logs/jenkins.log
   ```

**Interface Jenkins 2.516.2 - "New Item" não aparece:**

1. **Primeiro acesso - Configuração inicial:**
   - Aguarde a tela de "Unlock Jenkins"
   - Use a senha inicial do log/arquivo
   - Complete o wizard de configuração

2. **Após configuração inicial:**
   - Procure por "**+ New Item**" no menu lateral esquerdo
   - Ou use "**Create a job**" na página principal
   - Ou acesse diretamente: `http://localhost:8080/view/all/newJob`

**Erro de permissão de Docker:**
```bash
# Adicionar Jenkins ao grupo docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**Node.js não encontrado:**
- Verifique se o Node.js está configurado em "Global Tool Configuration"
- Certifique-se de que o nome corresponde ao usado no Jenkinsfile

**Testes falhando:**
- Verifique se todas as dependências estão instaladas
- Verifique se o workspace está limpo

### Logs Úteis

```bash
# Logs do Jenkins (Docker)
docker logs jenkins

# Logs do Jenkins (instalação local)
tail -f ~/.jenkins/logs/jenkins.log
```

## 📚 Recursos Adicionais

- [Documentação Oficial do Jenkins](https://jenkins.io/doc/)
- [Pipeline Syntax Reference](https://jenkins.io/doc/book/pipeline/syntax/)
- [Plugin Index](https://plugins.jenkins.io/)
- [Jenkins Best Practices](https://jenkins.io/doc/book/pipeline/pipeline-best-practices/)

---

💡 **Dica**: Comece com uma configuração simples e vá adicionando complexidade gradualmente conforme suas necessidades.
