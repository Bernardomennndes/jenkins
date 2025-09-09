const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para parsing JSON
app.use(express.json());

// Rota básica
app.get('/', (req, res) => {
  res.json({
    message: 'Bem-vindo ao projeto Node.js com Jenkins CI/CD!',
    status: 'OK',
    timestamp: new Date().toISOString()
  });
});

// Rota para health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Rota para calcular soma (para teste)
app.post('/calculate/sum', (req, res) => {
  const { a, b } = req.body;
  
  if (typeof a !== 'number' || typeof b !== 'number') {
    return res.status(400).json({
      error: 'Parâmetros a e b devem ser números'
    });
  }
  
  const result = a + b;
  res.json({
    operation: 'sum',
    a,
    b,
    result
  });
});

// Função para calcular soma (exportada para testes)
function sum(a, b) {
  return a + b;
}

// Função para calcular multiplicação
function multiply(a, b) {
  return a * b;
}

// Middleware de tratamento de erro
app.use((err, req, res, _next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Algo deu errado!',
    message: err.message
  });
});

// Iniciar servidor apenas se não estiver em ambiente de teste
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando na porta ${PORT}`);
    console.log(`📡 Acesse: http://localhost:${PORT}`);
  });
}

module.exports = { app, sum, multiply };
