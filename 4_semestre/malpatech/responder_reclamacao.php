<?php
session_start();

// Verificar se o usuário está logado (empresa)
if (!isset($_SESSION["cnpj"])) {
    header("Location: login_empresa.html"); // Redirecionar para a página de login da empresa se não estiver logado
    exit();
}

// Conectar ao banco de dados
$conn = new mysqli("localhost", "root", "", "BD_Malpa");

if ($conn->connect_error) {
    die("Erro na conexão com o banco de dados: " . $conn->connect_error);
}

// Verificar se o ID da reclamação foi fornecido na URL
if (isset($_GET["id"])) {
    $reclamacao_id = $_GET["id"];
} else {
    echo "ID da reclamação não fornecido na URL.";
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $resposta = $_POST["resposta"];

    // Atualizar a reclamação no banco de dados com a resposta da empresa
    $sql = "UPDATE denuncias SET resposta = ? WHERE id = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("si", $resposta, $reclamacao_id);

    if ($stmt->execute()) {
        $_SESSION['mensagem_sucesso'] = 'Resposta enviada com sucesso!';
        header("Location: exibir_reclamacoes.php"); // Redirecionar de volta para a página de exibição de reclamações
    } else {
        echo "Erro no envio da resposta: " . $stmt->error;
    }

    // Fechar a conexão
    $stmt->close();
}

// Fechar a conexão
$conn->close();
?>
