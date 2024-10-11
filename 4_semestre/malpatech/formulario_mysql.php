<?php
session_start();

// Conectar ao banco de dados
$conn = new mysqli("localhost", "root", "", "BD_Malpa");

if ($conn->connect_error) {
    die("Erro na conexão com o banco de dados: " . $conn->connect_error);
}

// Receber dados do formulário
$nome = $_POST["nome"];
$endereco = $_POST["endereco"];
$numero = $_POST["numero"];
$bairro = $_POST["bairro"];
$descricao_problema = $_POST["descricao_problema"];

// Preparar a declaração SQL
$sql = "INSERT INTO denuncias (nome, endereco, numero, bairro, descricao_problema) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

if ($stmt) {
    // Vincular parâmetros
    $stmt->bind_param("ssiss", $nome, $endereco, $numero, $bairro, $descricao_problema);

    // Executar a consulta
    if ($stmt->execute()) {
        $_SESSION['mensagem_sucesso'] = 'A reclamação foi registrada com sucesso!';
        header("Location: https://malpa.tech"); // Redirecionar para o site Malpa
    } else {
        echo "Erro no registro da reclamação: " . $stmt->error;
    }

    // Fechar a declaração preparada
    $stmt->close();
} else {
    echo "Erro na preparação da consulta: " . $conn->error;
}

// Fechar a conexão
$conn->close();
?>
