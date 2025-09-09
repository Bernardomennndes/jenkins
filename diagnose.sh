#!/bin/bash

echo "🔍 Diagnóstico do Pipeline Jenkins"
echo "================================"
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Este script deve ser executado no diretório do projeto"
    echo "📁 Navegue para: /Users/bernardomennndes/Documents/projects/university/jenkins"
    exit 1
fi

echo "✅ Diretório correto encontrado"
echo ""

# Verificar arquivos essenciais
echo "📋 Verificando arquivos essenciais:"
files=("package.json" "src/app.js" "test/app.test.js" "Jenkinsfile")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - FALTANDO!"
    fi
done
echo ""

# Verificar Jenkinsfiles disponíveis
echo "📋 Jenkinsfiles disponíveis:"
jenkinsfiles=("Jenkinsfile" "Jenkinsfile.simple" "Jenkinsfile.robust" "Jenkinsfile.alternative")
for file in "${jenkinsfiles[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - não encontrado"
    fi
done
echo ""

# Verificar Node.js
echo "📋 Verificando Node.js local:"
if command -v node &> /dev/null; then
    echo "  ✅ Node.js: $(node --version)"
else
    echo "  ❌ Node.js não encontrado"
fi

if command -v npm &> /dev/null; then
    echo "  ✅ npm: $(npm --version)"
else
    echo "  ❌ npm não encontrado"
fi
echo ""

# Verificar dependências
echo "📋 Verificando dependências:"
if [ -d "node_modules" ]; then
    echo "  ✅ node_modules existe"
    echo "  📊 Pacotes instalados: $(ls node_modules | wc -l | tr -d ' ')"
else
    echo "  ❌ node_modules não encontrado"
    echo "  💡 Execute: npm install"
fi
echo ""

# Testar scripts npm
echo "📋 Testando scripts npm:"
scripts=("test" "lint" "build")
for script in "${scripts[@]}"; do
    if npm run $script --silent &> /dev/null; then
        echo "  ✅ npm run $script - OK"
    else
        echo "  ⚠️  npm run $script - FALHA"
    fi
done
echo ""

# Verificar Git
echo "📋 Verificando Git:"
if git status &> /dev/null; then
    echo "  ✅ Repositório Git: $(git branch --show-current)"
    echo "  📊 Status: $(git status --porcelain | wc -l | tr -d ' ') arquivos modificados"
else
    echo "  ❌ Não é um repositório Git ou Git não configurado"
fi
echo ""

# Sugestões baseadas no diagnóstico
echo "💡 Sugestões:"
echo ""

if [ ! -d "node_modules" ]; then
    echo "1. Instalar dependências:"
    echo "   npm install"
    echo ""
fi

if [ -f "Jenkinsfile.robust" ]; then
    echo "2. Para pipelines mais robustos, use:"
    echo "   mv Jenkinsfile Jenkinsfile.original"
    echo "   mv Jenkinsfile.robust Jenkinsfile"
    echo ""
fi

echo "3. URLs úteis do Jenkins:"
echo "   Dashboard: http://localhost:8080"
echo "   Global Tools: http://localhost:8080/manage/configureTools/"
echo "   Console do último build: http://localhost:8080/job/node-cicd-pipeline/lastBuild/console"
echo ""

echo "4. Para verificar logs do Jenkins:"
echo "   docker logs jenkins  # se usando Docker"
echo "   brew services list | grep jenkins  # se instalação local"
echo ""
