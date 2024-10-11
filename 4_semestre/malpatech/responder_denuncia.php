<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="csslogin/empresa.css">

    <title>Responder à Denúncia</title>
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

        h2 {
            color: #fff;
            text-align: center;
        }

        .container {
            width: 50%;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        p {
            margin: 10px 0;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        textarea {
            width: 100%;
            height: 100px;
            margin-top: 5px;
            resize: vertical;
        }

        input[type="submit"] {
            background-color: #253E8F;
            color: #fff;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #253E8F;
        }
    </style>
</head>
<body>
    <header>
        <h2>Responder à Denúncia</h2>
    </header>

    <div class="container">
        <?php
        session_start();

        // Verificar se o ID da denúncia foi fornecido na URL
        if (isset($_GET['id'])) {
            $id_denuncia = $_GET['id'];

            // Conectar ao banco de dados
            $conn = new mysqli("localhost", "root", "", "BD_Malpa");

            if ($conn->connect_error) {
                die("Erro na conexão com o banco de dados: " . $conn->connect_error);
            }

            // Consulta para obter informações da denúncia
            $sql = "SELECT * FROM denuncias WHERE id_denuncia = $id_denuncia";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                $denuncia = $result->fetch_assoc();

                // Exibir informações da denúncia
                echo "<div class='complaint'>";
                echo "<p><strong>Nome:</strong> {$denuncia['nome']}</p>
                      <p><strong>Endereço:</strong> {$denuncia['endereco']}, {$denuncia['numero']}, {$denuncia['bairro']}</p>
                      <p><strong>Descrição do Problema:</strong> {$denuncia['descricao_problema']}</p>";

                // Formulário para a resposta
                echo "<form action='processar_resposta.php' method='post'>
                        <input type='hidden' name='id_denuncia' value='$id_denuncia'>
                        <label for='resposta'>Resposta:</label>
                        <textarea name='resposta' required></textarea><br>
                        <input type='submit' value='Enviar Resposta'>
                      </form>";
            } else {
                echo "<p style='text-align: center;'>Denúncia não encontrada.</p>";
            }
            echo "</div>";


            // Fechar a conexão
            $conn->close();
        } else {
            echo "<p style='text-align: center;'>ID da denúncia não fornecido.</p>";
        }

        ?>
    </div>
</body>
</html>
