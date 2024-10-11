<?php
session_start();

// Verificar se todos os campos estão presentes
if (isset($_POST['id_denuncia']) && isset($_POST['resposta'])) {
    $id_denuncia = $_POST['id_denuncia'];
    $resposta = $_POST['resposta'];

    // Conectar ao banco de dados
    $conn = new mysqli("localhost", "root", "", "BD_Malpa");

    if ($conn->connect_error) {
        die("Erro na conexão com o banco de dados: " . $conn->connect_error);
    }

    // Inserir a resposta na tabela responder_reclamacoes
    $sqlInsertResposta = "INSERT INTO responder_reclamacoes (id_denuncia, resposta, data_resposta) VALUES (?, ?, NOW())";

    $sua_id_empresa = 6; // Substitua pelo ID real da sua empresa

    $stmtInsertResposta = $conn->prepare($sqlInsertResposta);
    $stmtInsertResposta->bind_param("si", $id_denuncia, $resposta);

    if ($stmtInsertResposta->execute()) {
        // Atualizar a denúncia com a resposta
        $sqlUpdate = "UPDATE denuncias SET resposta_empresa = ? WHERE id_denuncia = ?";
        $stmtUpdate = $conn->prepare($sqlUpdate);
        $stmtUpdate->bind_param("si", $resposta, $id_denuncia);

        if ($stmtUpdate->execute()) {
            // Redirecionar para a página que exibe a denúncia e a resposta
            header("Location: exibir_denuncia.php?id=$id_denuncia");
            exit();
        } else {
            echo "Erro ao atualizar a denúncia: " . $stmtUpdate->error;
        }

        // Fechar a declaração preparada de atualização
        $stmtUpdate->close();
    } else {
        echo "Erro ao inserir a resposta: " . $stmtInsertResposta->error;
    }

    // Fechar a declaração preparada de inserção
    $stmtInsertResposta->close();

    // Fechar a conexão
    $conn->close();
} else {
    echo "Todos os campos são obrigatórios.";
}
?>