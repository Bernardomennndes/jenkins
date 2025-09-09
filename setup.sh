#!/bin/bash

echo "🚀 Configurando projeto Node.js com Jenkins CI/CD..."

# Verificar se Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado. Por favor, instale Node.js primeiro."
    exit 1
fi

# Verificar versão do Node.js
NODE_VERSION=$(node --version)
echo "✅ Node.js encontrado: $NODE_VERSION"

# Instalar dependências
echo "📦 Instalando dependências..."
npm install

# Executar testes para verificar se tudo está funcionando
echo "🧪 Executando testes..."
npm test

# Executar lint
echo "🔍 Executando lint..."
npm run lint

echo ""
echo "✅ Projeto configurado com sucesso!"
echo ""
echo "📋 Próximos passos:"
echo "   1. Execute 'npm run dev' para iniciar em modo desenvolvimento"
echo "   2. Acesse http://localhost:3000 para ver a aplicação"
echo "   3. Configure o Jenkins apontando para este repositório"
echo "   4. O pipeline será executado automaticamente"
echo ""
echo "🔧 Comandos úteis:"
echo "   npm run dev     - Inicia em modo desenvolvimento"
echo "   npm test        - Executa testes"
echo "   npm run build   - Executa build"
echo "   npm run lint    - Executa análise de código"
echo ""
