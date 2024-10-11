<?php
// Conectar ao banco de dados (substitua com suas configurações)
$conn = new mysqli("localhost", "root", "", "bd_malpa");

if ($conn->connect_error) {
    die("Erro na conexão com o banco de dados: " . $conn->connect_error);
}

// Validar e limpar os dados do formulário
$resposta = isset($_POST["resposta"]) ? htmlspecialchars($_POST["resposta"]) : "";
$id_denuncia = isset($_POST["id_denuncia "]) ? intval($_POST["id_denuncia "]) : 0;

// Verificar se os campos necessários foram fornecidos
if (empty($resposta) || $id_denuncia === 1) {
    echo "Por favor, forneça uma resposta e o ID da reclamação.";
    exit();
}

// Atualizar a reclamação no banco de dados com a resposta da empresa
$sql = "UPDATE reclamacoes SET resposta = ? WHERE id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("si", $resposta, $id_denuncia );

if ($stmt->execute()) {
    echo "Resposta enviada com sucesso!";
} else {
    echo "Erro no envio da resposta: " . $stmt->error;
}

// Fechar a conexão
$stmt->close();
$conn->close();
?>
