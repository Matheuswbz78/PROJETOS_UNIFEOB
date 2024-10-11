const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/auth');
const { registrarAuditoria, registrarLogAcesso } = require('../middleware/logger');

router.get('/logger', verifyToken, (req, res) => {
    console.log("UserID from token:", req.user.id); // Isso deve logar o ID do usuário
    const userId = req.user.id;

    // Exemplo de como registrar auditoria e log de acesso
    registrarAuditoria(userId, 'VIEW', 'SomeTable', 'Visualizou a página de logs');
    registrarLogAcesso(userId, req.ip, 'VIEW_LOGGER', 'Sucesso');

    res.json({ message: 'Logs registrados com sucesso' });
});

module.exports = router;
