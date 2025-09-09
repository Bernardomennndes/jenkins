const request = require('supertest');
const { app, sum, multiply } = require('../src/app');

describe('Aplicação Node.js', () => {
  
  describe('Testes de Funções', () => {
    test('deve somar dois números corretamente', () => {
      expect(sum(2, 3)).toBe(5);
      expect(sum(-1, 1)).toBe(0);
      expect(sum(0, 0)).toBe(0);
    });

    test('deve multiplicar dois números corretamente', () => {
      expect(multiply(2, 3)).toBe(6);
      expect(multiply(-2, 3)).toBe(-6);
      expect(multiply(0, 5)).toBe(0);
    });
  });

  describe('Testes de API', () => {
    test('GET / deve retornar mensagem de boas-vindas', async () => {
      const response = await request(app)
        .get('/')
        .expect(200);

      expect(response.body).toHaveProperty('message');
      expect(response.body).toHaveProperty('status', 'OK');
      expect(response.body).toHaveProperty('timestamp');
    });

    test('GET /health deve retornar status de saúde', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      expect(response.body).toHaveProperty('status', 'healthy');
      expect(response.body).toHaveProperty('uptime');
      expect(response.body).toHaveProperty('timestamp');
    });

    test('POST /calculate/sum deve calcular soma corretamente', async () => {
      const response = await request(app)
        .post('/calculate/sum')
        .send({ a: 5, b: 3 })
        .expect(200);

      expect(response.body).toEqual({
        operation: 'sum',
        a: 5,
        b: 3,
        result: 8
      });
    });

    test('POST /calculate/sum deve retornar erro para parâmetros inválidos', async () => {
      const response = await request(app)
        .post('/calculate/sum')
        .send({ a: 'invalid', b: 3 })
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });

    test('Rota inexistente deve retornar 404', async () => {
      await request(app)
        .get('/rota-inexistente')
        .expect(404);
    });
  });
});
