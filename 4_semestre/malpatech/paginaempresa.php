<!DOCTYPE html>
<html lang="pt-br">

<head>
    <link rel="icon" type="image/png" href="images/logomalpa.ico" />

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>malpa - Prefeitura</title>
    <link rel="stylesheet" type="text/css" href="csslogin/empresa.css">
</head>

<body>
    
    <div>
        <img class="imagembackgroud" src="images/profilebackgroud.png" alt="Banner da Empresa">
    </div>

    <div class="cabecalho">
        <img class="imagemheader" src="imagens/fotonaodisponivel.png" alt="Logo da Empresa">
        <h1 class="profile-name">Prefeitura</h1>
        <h5 class="profile-subname">São João da Boa Vista - SP</h5>
    </div>

    <div class="horizontal-line"></div>

    <div>
        <a class="empresa-info" href="https://www.saojoao.sp.gov.br">Saiba Mais</a>
    </div>

    <div class="complaints">
        <h2>Denúncias Recentes</h2>
        <a class="fazer-denuncia" href="dashboard.php">Fazer uma Denúncia</a>
        <?php
        session_start();

        // Conectar ao banco de dados
        $conn = new mysqli("localhost", "root", "", "BD_Malpa");

        if ($conn->connect_error) {
            die("Erro na conexão com o banco de dados: " . $conn->connect_error);
        }

        // Recuperar as reclamações do banco de dados
        $sql = "SELECT * FROM denuncias";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                echo "<div class='complaint'>";
                echo "<p><strong>Nome:</strong> " . $row["nome"] . "</p>";

                // Combinação de Endereço, Número e Bairro em um único campo chamado "Endereço"
                $enderecoCompleto = $row["endereco"] . ", " . $row["numero"] . ", " . $row["bairro"];
                echo "<p><strong>Endereço:</strong> " . $enderecoCompleto . "</p>";

                echo "<p><strong>Descrição do Problema:</strong> " . $row["descricao_problema"] . "</p>";

                // Exibir a resposta como um comentário
                if (!empty($row['resposta_empresa'])) {
                    echo "<div class='resposta-comentario'>";
                    echo "<p><strong>Resposta:</strong> {$row['resposta_empresa']}</p>";
                    echo "</div>";
                }

                // Verificar se o campo "id_denuncia" existe antes de criar o link "Responder"
                if (isset($row["id_denuncia"])) {
                    // Adicione um link ou botão "Responder" que direciona para a página de resposta com o ID da reclamação
                    echo "<a class='responder-denuncia' href='pagina_empresa.php?id=" . $row["id_denuncia"] . "'>Responder</a>";
                } else {
                    echo "ID da reclamação não encontrado.";
                }

                echo "</div>";
            }
        } else {
            echo "Nenhuma reclamação registrada ainda.";
        }

        // Fechar a conexão
        $conn->close();
        ?>
    </div>
</body>

</html>
