const db = require('../config/db');

const registrarLogAcesso = (usuario, ip_origem, acao, resultado, ativo = true) => {
    const sqlInsertLog = `
        INSERT INTO LogAcessos (usuario, ip_origem, acao, resultado, ativo)
        VALUES (?, ?, ?, ?, ?)
    `;
    db.query(sqlInsertLog, [usuario, ip_origem, acao, resultado, ativo], (err) => {
        if (err) {
            console.error("Erro ao registrar log de acesso:", err);
        }
    });
};

const atualizarSessaoAtiva = (usuario, ativo) => {
    const sqlUpdateLog = `
        UPDATE LogAcessos
        SET ativo = ?
        WHERE usuario = ? AND ativo = TRUE
    `;
    db.query(sqlUpdateLog, [ativo, usuario], (err) => {
        if (err) {
            console.error("Erro ao atualizar sessão ativa:", err);
        }
    });
};

module.exports = { registrarLogAcesso, atualizarSessaoAtiva };
