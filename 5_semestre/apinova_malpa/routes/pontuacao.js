const express = require('express');
const router = express.Router();
const db = require('../config/db');
const verifyToken = require('../middleware/auth');

router.get('/pontuacao', verifyToken, (req, res) => {
    console.log("UserID from token:", req.user.id);
    const userId = req.user.id;
    
    // Consulta para buscar pontuação atual
    const sqlSelectPontuacao = "SELECT pontuacao_atual FROM Pontuacao WHERE id = ?";
    
    // Consulta para buscar dados do gráfico
    const sqlSelectGrafico = "SELECT x, pontuacao_atual FROM graphic WHERE id = ?";

    db.query(sqlSelectPontuacao, [userId], (err, pontuacaoResults) => {
        console.log("Points results:", pontuacaoResults); // Ver o que está sendo retornado
        if (err) {
            console.error("Erro ao buscar pontuação:", err);
            return res.status(500).json({ error: err.message });
        }
        if (pontuacaoResults.length === 0) {
            return res.status(404).json({ message: "Pontuação não encontrada!" });
        }

        const pontuacao = pontuacaoResults[0].pontuacao_atual;

        db.query(sqlSelectGrafico, [userId], (err, graficoResults) => {
            console.log("Graphic results:", graficoResults);
            if (err) {
                console.error("Erro ao buscar dados do gráfico:", err);
                return res.status(500).json({ error: err.message });
            }

            res.json({
                pontuacao_atual: pontuacao,
                grafico: graficoResults // Retorna os dados do gráfico
            });
        });
    });
});

module.exports = router;
