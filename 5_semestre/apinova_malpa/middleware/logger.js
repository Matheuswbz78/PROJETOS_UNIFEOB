const db = require('../config/db');

// Função para registrar auditoria
const registrarAuditoria = (usuario, acao, tabela, detalhes) => {
    const sqlInsertAuditoria = `
        INSERT INTO Auditoria (usuario, acao, tabela, detalhes)
        VALUES (?, ?, ?, ?)
    `;
    db.query(sqlInsertAuditoria, [usuario, acao, tabela, detalhes], (err) => {
        if (err) {
            console.error("Erro ao registrar auditoria:", err);
        }
    });
};

// Função para registrar log de acesso
const registrarLogAcesso = (usuario, ip_origem, acao, resultado) => {
    const sqlInsertLog = `
        INSERT INTO LogAcessos (usuario, ip_origem, acao, resultado)
        VALUES (?, ?, ?, ?)
    `;
    db.query(sqlInsertLog, [usuario, ip_origem, acao, resultado], (err) => {
        if (err) {
            console.error("Erro ao registrar log de acesso:", err);
        }
    });
};

module.exports = {
    registrarAuditoria,
    registrarLogAcesso
};
