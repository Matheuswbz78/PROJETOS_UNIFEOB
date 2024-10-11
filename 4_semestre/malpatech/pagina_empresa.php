<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Página da Empresa</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #253E8F;
            color: #fff;
            padding: 15px;
            text-align: center;
        }

        h1 {
            color: #fff;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #253E8F;
            color: #fff;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        a {
            text-decoration: none;
            color: #253E8F;
            font-weight: bold;
        }

        a:hover {
            color: #253E8F;
        }

        .container {
            width: 80%;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <header>
        <h1>Denúncias Recebidas</h1>
    </header>

    <div class=complain class="container">
        <?php
        session_start();

        // Conectar ao banco de dados
        $conn = new mysqli("localhost", "root", "", "BD_Malpa");

        // Verificar se a conexão foi bem-sucedida
        if ($conn->connect_error) {
            die("Erro na conexão com o banco de dados: " . $conn->connect_error);
        }

        // Consulta para obter as denúncias
        $sql = "SELECT * FROM denuncias";
        $result = $conn->query($sql);

        // Verificar se a consulta foi bem-sucedida
        if ($result === false) {
            echo "Erro na consulta: " . $conn->error;
        } else {
            if ($result->num_rows > 0) {
                // Exibir as denúncias em uma tabela
                echo "<table>
                        <tr>
                            <th>ID</th>
                            <th>Nome</th>
                            <th>Endereço</th>
                            <th>Número</th>
                            <th>Bairro</th>
                            <th>Descrição do Problema</th>
                            <th>Ação</th>
                        </tr>";

                while ($row = $result->fetch_assoc()) {
                    echo "<tr>
                            <td>{$row['id_denuncia']}</td>
                            <td>{$row['nome']}</td>
                            <td>{$row['endereco']}</td>
                            <td>{$row['numero']}</td>
                            <td>{$row['bairro']}</td>
                            <td>{$row['descricao_problema']}</td>
                            <td><a href='responder_denuncia.php?id={$row['id_denuncia']}'>Responder</a></td>
                        </tr>";
                }

                echo "</table>";
            } else {
                echo "<p style='text-align: center;'>Não há denúncias registradas.</p>";
            }
        }

        // Fechar a conexão
        $conn->close();
        ?>
    </div>
</body>
</html>

