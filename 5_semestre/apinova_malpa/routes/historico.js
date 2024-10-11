const express = require('express');
const router = express.Router();
const db = require('../config/db');
const verifyToken = require('../middleware/auth');

router.get('/historico', verifyToken, (req, res) => {
    console.log("UserID from token:", req.user.id); // Isso deve logar o ID do usuário
    const userId = req.user.id;
    const sqlSelect = "SELECT tipo, quantidade, DATE_FORMAT(timestamp, '%d-%m-%y') AS timestamp FROM graphic WHERE id = ? ORDER BY timestamp DESC LIMIT 5"; // Supondo que haja uma coluna 'timestamp' para ordenar
    db.query(sqlSelect, [userId], (err, results) => {
        console.log("History results:", results); // Ver o que está sendo retornado
        if (err) {
            console.error("Erro ao buscar histórico:", err);
            return res.status(500).json({ error: err.message });
        }
        if (results.length === 0) {
            return res.status(404).json({ message: "Item não encontrado!" });
        }
        res.json(results); // Retorna todos os resultados relevantes
    });
});

module.exports = router;
