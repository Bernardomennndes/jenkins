#!/bin/bash

echo "🔍 Verificando status do Jenkins..."
echo ""

# Verificar se Docker está rodando
if command -v docker &> /dev/null; then
    echo "✅ Docker encontrado"
    
    # Verificar se container Jenkins está rodando
    if docker ps | grep -q jenkins; then
        echo "✅ Container Jenkins está rodando"
        
        # Verificar logs do Jenkins
        echo "📋 Últimas linhas do log do Jenkins:"
        docker logs jenkins --tail 10
        
        echo ""
        echo "🔑 Senha inicial do Jenkins:"
        docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "❌ Arquivo de senha não encontrado"
        
    else
        echo "❌ Container Jenkins não está rodando"
        echo "💡 Execute: docker-compose up jenkins"
    fi
else
    echo "❌ Docker não encontrado"
fi

echo ""

# Verificar se Jenkins está instalado localmente
if command -v jenkins-lts &> /dev/null; then
    echo "✅ Jenkins LTS encontrado localmente"
    
    # Verificar se serviço está rodando
    if brew services list | grep -q jenkins-lts; then
        echo "✅ Serviço Jenkins está configurado"
        brew services list | grep jenkins
    else
        echo "❌ Serviço Jenkins não configurado"
        echo "💡 Execute: brew services start jenkins-lts"
    fi
else
    echo "ℹ️  Jenkins não instalado localmente (usando Docker)"
fi

echo ""

# Testar conexão com Jenkins
echo "🌐 Testando conexão com Jenkins..."
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ Jenkins respondendo em http://localhost:8080"
    
    # Verificar se é página de unlock
    if curl -s http://localhost:8080 | grep -q "Unlock Jenkins"; then
        echo "🔓 Jenkins aguardando unlock inicial"
    elif curl -s http://localhost:8080 | grep -q "Dashboard"; then
        echo "✅ Jenkins configurado e funcionando"
    else
        echo "⚠️  Jenkins respondendo mas status desconhecido"
    fi
else
    echo "❌ Jenkins não está respondendo em http://localhost:8080"
    echo "💡 Verifique se o serviço está rodando"
fi

echo ""
echo "🔧 URLs úteis:"
echo "   Dashboard: http://localhost:8080"
echo "   Criar job: http://localhost:8080/view/all/newJob"
echo "   Logs: http://localhost:8080/log/all"
echo ""
