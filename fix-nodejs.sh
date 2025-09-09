#!/bin/bash

echo "🔧 Script para configurar Node.js no Jenkins via linha de comando"
echo ""

# Verificar se Jenkins está rodando
if ! curl -s http://localhost:8080 > /dev/null; then
    echo "❌ Jenkins não está rodando em http://localhost:8080"
    echo "💡 Inicie o Jenkins primeiro"
    exit 1
fi

echo "✅ Jenkins está rodando"
echo ""

# Verificar se precisa de autenticação
if curl -s http://localhost:8080 | grep -q "Authentication required"; then
    echo "🔐 Jenkins requer autenticação"
    echo "📋 Siga estas etapas manuais:"
    echo ""
    echo "1. Acesse: http://localhost:8080/manage/configureTools/"
    echo "2. Role até 'NodeJS installations'"
    echo "3. Clique em 'Add NodeJS'"
    echo "4. Configure:"
    echo "   - Name: Node18"
    echo "   - Install automatically: ✅"
    echo "   - Version: NodeJS 18.x (latest)"
    echo "5. Clique em 'Save'"
    echo ""
else
    echo "ℹ️  Jenkins está acessível sem autenticação"
fi

echo "🔗 Links úteis:"
echo "   Dashboard: http://localhost:8080"
echo "   Global Tools: http://localhost:8080/manage/configureTools/"
echo "   Node.js Tools: http://localhost:8080/manage/configureTools/#tool_NodeJSInstallation"
echo ""

echo "📋 Próximos passos após configurar Node.js:"
echo "1. Verificar se 'Node18' foi criado em Global Tool Configuration"
echo "2. Executar o pipeline novamente"
echo "3. Se ainda falhar, usar o Jenkinsfile alternativo"
echo ""

# Verificar se existe o Jenkinsfile alternativo
if [ -f "Jenkinsfile.alternative" ]; then
    echo "💡 Para usar o Jenkinsfile alternativo (que instala Node.js automaticamente):"
    echo "   mv Jenkinsfile Jenkinsfile.original"
    echo "   mv Jenkinsfile.alternative Jenkinsfile"
    echo ""
fi
