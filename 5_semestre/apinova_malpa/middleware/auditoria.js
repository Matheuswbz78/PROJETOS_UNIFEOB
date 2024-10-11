const db = require('../config/db');

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

module.exports = registrarAuditoria;
