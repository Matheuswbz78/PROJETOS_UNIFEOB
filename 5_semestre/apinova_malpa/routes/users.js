const express = require('express');
const router = express.Router();
const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const verifyToken = require('../middleware/auth');
const { body, validationResult } = require('express-validator');
const { registrarAuditoria, registrarLogAcesso } = require('../middleware/logger');

router.use(cors());

const registerValidation = [
    body('email').isEmail().withMessage('Forneça um e-mail válido.'),
    body('password').isLength({ min: 6 }).withMessage('A senha deve ter pelo menos 6 caracteres.')
];

router.post('/register', registerValidation, async (req, res) => {
    console.log("Informações recebidas:", req.body);
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { name, email, password, address, addressNumber, city, zipCode, neighborhood } = req.body;
    try {
        const salt = await bcrypt.genSalt(10);
        const senhaHash = await bcrypt.hash(password, salt);
        const sqlInsert = "INSERT INTO usuarios (nome, email, senha, endereco, numero_endereco, cidade, cep, bairro) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        db.query(sqlInsert, [name, email, senhaHash, address || null, addressNumber || null, city || null, zipCode || null, neighborhood || null], (err, result) => {
            if (err) {
                console.error("Erro ao inserir usuário no banco de dados:", err);
                return res.status(500).json({ error: err.message });
            }
            registrarAuditoria(name, 'REGISTER', 'usuarios', 'Cadastro de novo usuário');
            registrarLogAcesso(name, req.ip, 'POST', 'Registro bem-sucedido');
            res.status(201).json({ message: "Usuário cadastrado com sucesso!" });
        });
    } catch (err) {
        console.error("Erro durante o cadastro do usuário:", err);
        registrarLogAcesso('desconhecido', req.ip, 'POST', 'Erro no registro');
        res.status(500).json({ error: err.message });
    }
});

router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).json({ message: "Email e senha são obrigatórios" });
    }
    try {
        const sqlSelect = "SELECT id, nome, senha FROM usuarios WHERE email = ?";
        db.query(sqlSelect, [email], async (err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            if (results.length === 0) {
                registrarLogAcesso(email, req.ip, 'POST', 'Usuário não encontrado');
                return res.status(404).json({ message: "Usuário não encontrado!" });
            }
            const user = results[0];
            const isMatch = await bcrypt.compare(password, user.senha);
            if (isMatch) {
                const token = jwt.sign({ id: user.id, name: user.nome }, process.env.JWT_SECRET, { expiresIn: '1h' });
                registrarLogAcesso(user.nome, req.ip, 'POST', 'Login bem-sucedido');
                return res.status(200).json({ message: "Login bem-sucedido!", token });
            } else {
                registrarLogAcesso(user.nome, req.ip, 'POST', 'Senha incorreta');
                return res.status(400).json({ message: "Senha incorreta!" });
            }
        });
    } catch (error) {
        registrarLogAcesso(email, req.ip, 'POST', 'Erro no login');
        res.status(500).json({ error: 'Erro interno do servidor' });
    }
});

router.get('/meu-perfil', verifyToken, (req, res) => {
    res.status(200).json({ message: "Acesso permitido", userData: req.user });
});

router.get('/perfil', verifyToken, (req, res) => {
    console.log("UserID from token:", req.user.id); // Isso deve logar 10
    const userId = req.user.id;
    const sqlSelect = "SELECT nome, email, endereco, numero_endereco, cidade, cep, bairro FROM usuarios WHERE id = ?";
    db.query(sqlSelect, [userId], (err, results) => {
        console.log("DB Query results:", results); // Ver o que está sendo retornado
        if (err) {
            console.error("Erro ao buscar perfil:", err);
            return res.status(500).json({ error: err.message });
        }
        if (results.length === 0) {
            return res.status(404).json({ message: "Perfil não encontrado!" });
        }
        res.json(results[0]); // Retorna o primeiro resultado
    });
});

router.put('/atualizar-perfil', verifyToken, (req, res) => {
    const userId = req.user.id;
    const { nome, email, endereco, numero_endereco, cidade, cep } = req.body;
    const sqlUpdate = "UPDATE usuarios SET nome = ?, email = ?, endereco = ?, numero_endereco = ?, cidade = ?, cep = ? WHERE id = ?";
    db.query(sqlUpdate, [nome, email, endereco, numero_endereco, cidade, cep, userId], (err, result) => {
        if (err) {
            console.error("Erro ao atualizar perfil no banco de dados:", err);
            return res.status(500).json({ error: err.message });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: "Perfil não encontrado!" });
        }
        res.json({ message: "Perfil atualizado com sucesso!" });
    });
});

module.exports = router;
