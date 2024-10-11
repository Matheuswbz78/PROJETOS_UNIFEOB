const express = require('express');
const app = express();
require('dotenv').config();

// Middleware para parsing de JSON
app.use(express.json());

// Importação das rotas
const userRoutes = require('./routes/users');
const pontuacaoRoutes = require('./routes/pontuacao');
const historicoRoutes = require('./routes/historico');
const logRoutes = require('./routes/logger');

// Importação do middleware de auditoria
const registrarAuditoria = require('./middleware/auditoria');
const { registrarLogAcesso } = require('./middleware/logger');

// Middleware de auditoria - registra todos os acessos
app.use((req, res, next) => {
    const user = req.user ? req.user.name : 'desconhecido';
    const tabela = req.originalUrl.split('/')[2]; // Tabela pode ser inferida a partir da URL
    const detalhes = `Rota acessada: ${req.originalUrl}`;

    // Registra a auditoria
    registrarAuditoria(user, req.method, tabela, detalhes);

    // Continua para a próxima função de middleware/rota
    next();
});

// Middleware para logs de acesso - exemplo de uso global
app.use((req, res, next) => {
    const user = req.user ? req.user.name : 'desconhecido';
    const ip = req.ip;
    const acao = req.method;
    const url = req.originalUrl;

    // Vamos registrar a tentativa de acesso
    registrarLogAcesso(user, ip, acao, url);

    next();
});

// Definição das rotas
app.use('/api/users', userRoutes);
app.use('/api/pontuacao', pontuacaoRoutes);
app.use('/api/historico', historicoRoutes);
app.use('/api/logger', logRoutes);

// Middleware para tratamento de erros, deve ser o último middleware adicionado
app.use((err, req, res, next) => {
    console.error("Erro detalhado:", err.stack);
    const user = req.user ? req.user.name : 'desconhecido';
    registrarAuditoria(user, 'ERROR', 'server', err.message);
    registrarLogAcesso(user, req.ip, 'ERROR', 'Acesso negado');
    res.status(500).send('Algo deu errado!');
});

// Definição da porta e inicialização do servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
