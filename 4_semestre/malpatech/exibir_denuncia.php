<!DOCTYPE html>
<html lang="pt-br">
<head>
<link rel="icon" type="image/png" href="images/logomalpa.ico" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="csslogin/empresa.css">


    <title>Exibir Denúncias e Respostas</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

        div {
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin: 20px;
            border-radius: 8px;
            width: 80%;
        }

        p {
            margin: 10px 0;
            line-height: 1.5;
        }

        <style>
        .voltar {
            display: block;
            margin: 0 auto;
            text-align: center;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            font-size: 16px;
            border-radius: 5px;
        }
    </style>
    </style>
</head>
<body>
    <h1>Denúncias e Respostas</h1>
    <a class="voltar" href="paginaempresa.php">Ver minha página</a>
    
    <?php
    session_start();

    // Conectar ao banco de dados
    $conn = new mysqli("localhost", "root", "", "BD_Malpa");

    if ($conn->connect_error) {
        die("Erro na conexão com o banco de dados: " . $conn->connect_error);
    }

    // Consulta para obter todas as denúncias e respostas
    $sql = "SELECT d.*, r.resposta
            FROM denuncias d
            LEFT JOIN responder_reclamacoes r ON d.id_denuncia = r.id_denuncia";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Exibir todas as denúncias e respostas
        while ($row = $result->fetch_assoc()) {
            echo "<div class=complaint>";
            echo "<p><strong>Nome:</strong> {$row['nome']}</p>";
                // Combinação de Endereço, Número e Bairro em um único campo chamado "Endereço"
                $enderecoCompleto = $row["endereco"] . ", " . $row["numero"] . ", " . $row["bairro"];
                echo "<p><strong>Endereço:</strong> " . $enderecoCompleto . "</p>";

            echo "<p><strong>Descrição do Problema:</strong> {$row['descricao_problema']}</p>";
            echo "<p><strong>Resposta da Empresa:</strong> {$row['resposta_empresa']}</p>";
            echo "</div>";
        }
    } else {
        echo "<div>Não há denúncias registradas.</div>";
    }

    // Fechar a conexão
    $conn->close();
    ?>
</body>
</html>
