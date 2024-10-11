const jwt = require('jsonwebtoken');
const db = require('../config/db');

const verifyToken = (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (!token) {
        return res.status(401).json({ message: "Acesso negado. Token não fornecido." });
    }
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        // Obter o nome do usuário a partir do banco de dados
        const sqlSelectUser = "SELECT nome FROM usuarios WHERE id = ?";
        db.query(sqlSelectUser, [req.user.id], (err, results) => {
            if (err || results.length === 0) {
                return res.status(500).json({ message: "Erro ao obter o nome do usuário." });
            }
            req.user.name = results[0].nome;
            next();
        });
    } catch (err) {
        res.status(400).json({ message: "Token inválido." });
    }
};

module.exports = verifyToken;
