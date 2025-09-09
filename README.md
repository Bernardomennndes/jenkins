# Projeto Node.js com Jenkins CI/CD

Este é um projeto simples de Node.js que demonstra a implementação de um pipeline CI/CD usando Jenkins.

## 📋 Características

- **Aplicação Express.js** simples com API REST
- **Testes unitários** com Jest e Supertest
- **Pipeline CI/CD** configurado com Jenkins
- **Análise de código** com ESLint
- **Relatórios de cobertura** de testes

## 🚀 Como executar

### Pré-requisitos

- Node.js (versão 18 ou superior)
- npm ou yarn

### Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd jenkins-cicd-node-project
```

2. Instale as dependências:
```bash
npm install
```

### Executando localmente

```bash
# Modo desenvolvimento (com nodemon)
npm run dev

# Modo produção
npm start
```

A aplicação estará disponível em `http://localhost:3000`

## 🧪 Testes

```bash
# Executar todos os testes
npm test

# Executar testes em modo watch
npm run test:watch

# Verificar lint
npm run lint
```

## 📊 Endpoints da API

### GET /
Retorna uma mensagem de boas-vindas
```json
{
  "message": "Bem-vindo ao projeto Node.js com Jenkins CI/CD!",
  "status": "OK",
  "timestamp": "2025-09-08T10:00:00.000Z"
}
```

### GET /health
Health check da aplicação
```json
{
  "status": "healthy",
  "uptime": 123.456,
  "timestamp": "2025-09-08T10:00:00.000Z"
}
```

### POST /calculate/sum
Calcula a soma de dois números
```json
// Request
{
  "a": 5,
  "b": 3
}

// Response
{
  "operation": "sum",
  "a": 5,
  "b": 3,
  "result": 8
}
```

## 🔧 Jenkins Pipeline

O pipeline Jenkins está configurado no arquivo `Jenkinsfile` e inclui as seguintes etapas:

1. **Checkout**: Clona o código do repositório
2. **Setup Node.js**: Configura o ambiente Node.js
3. **Install Dependencies**: Instala as dependências do projeto
4. **Lint Code**: Executa análise de código
5. **Run Tests**: Executa os testes unitários
6. **Build**: Executa o processo de build
7. **Security Scan**: Verifica vulnerabilidades de segurança
8. **Package**: Cria o pacote da aplicação
9. **Deploy**: Deploy condicional baseado na branch

### Configuração no Jenkins

1. Crie um novo job do tipo "Pipeline"
2. Configure o SCM para apontar para este repositório
3. Configure o pipeline para usar o `Jenkinsfile`
4. Execute o pipeline

### Branches e Deploy

- **main**: Deploy para produção (requer confirmação manual)
- **develop**: Deploy automático para staging
- **outras branches**: Apenas testes e build

## 📁 Estrutura do Projeto

```
jenkins-cicd-node-project/
├── src/
│   └── app.js              # Aplicação principal
├── test/
│   └── app.test.js         # Testes unitários
├── Jenkinsfile             # Pipeline CI/CD
├── package.json            # Dependências e scripts
├── .eslintrc.js           # Configuração do ESLint
├── .gitignore             # Arquivos ignorados pelo Git
└── README.md              # Documentação
```

## 🔄 Fluxo de Desenvolvimento

1. **Desenvolvimento**: Criar feature branch a partir de `develop`
2. **Testes**: Pipeline executa testes automaticamente
3. **Code Review**: Pull Request para `develop`
4. **Staging**: Merge em `develop` dispara deploy para staging
5. **Produção**: Merge em `main` dispara deploy para produção

## 📈 Relatórios

O pipeline gera automaticamente:

- **Relatórios de teste**: Resultados dos testes unitários
- **Cobertura de código**: Relatório HTML com cobertura
- **Artefatos**: Pacotes prontos para deploy

## 🛠️ Tecnologias Utilizadas

- **Node.js**: Runtime JavaScript
- **Express.js**: Framework web
- **Jest**: Framework de testes
- **Supertest**: Testes de API
- **ESLint**: Análise de código
- **Jenkins**: CI/CD
- **npm**: Gerenciador de pacotes

## 📝 Licença

MIT License - veja o arquivo LICENSE para detalhes.
