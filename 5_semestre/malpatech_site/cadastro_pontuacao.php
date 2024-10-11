<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "malpa";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexão falhou: " . $conn->connect_error);
}

$sql = "SELECT id, email FROM usuarios";
$result = $conn->query($sql);

$clientes_options = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $clientes_options[] = "<option value='" . $row['id'] . "'>" . $row['email'] . "</option>";
    }
} else {
    $clientes_options[] = "<option value=''>Nenhum usuário registrado</option>";
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST["id"];
    $tipo = isset($_POST["tipo"]) ? $_POST["tipo"] : '';
    $quantidade = isset($_POST["quantidade"]) ? $_POST["quantidade"] : 0;
    $data = isset($_POST["data"]) ? date('m', strtotime($_POST["data"])) : date('m'); 

    switch ($tipo) {
        case 'Aluminio':
            $nova_pontuacao = $quantidade * 5;
            break;
        case 'Pilha':
            $nova_pontuacao = ($quantidade / 0.5) * 10;
            break;
        case 'Bateria':
            $nova_pontuacao = ($quantidade / 4) * 2;
            break;
        case 'Celular':
            $nova_pontuacao = $quantidade * 20;
            break;
        case 'Outros':
            $nova_pontuacao = $quantidade * 2;
            break;
        default:
            $nova_pontuacao = 0;
            break;
    }

    $conn->begin_transaction();

    try {
        $stmt = $conn->prepare("SELECT pontuacao_atual FROM Pontuacao WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $pontuacao_atual = $row['pontuacao_atual'] + $nova_pontuacao;

            $stmt = $conn->prepare("UPDATE Pontuacao SET pontuacao_atual = ?, tipo = ? WHERE id = ?");
            $stmt->bind_param("isi", $pontuacao_atual, $tipo, $id);
        } else {
            $pontuacao_atual = $nova_pontuacao;
            $stmt = $conn->prepare("INSERT INTO Pontuacao (id, tipo, pontuacao_atual) VALUES (?, ?, ?)");
            $stmt->bind_param("isi", $id, $tipo, $pontuacao_atual);
        }
        $stmt->execute();

        $stmt = $conn->prepare("INSERT INTO graphic (id, x, pontuacao_atual, tipo, quantidade) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("iisss", $id, $data, $pontuacao_atual, $tipo, $quantidade);
        $stmt->execute();

        $conn->commit();

        echo "<div class='alerta-sucesso'>Pontuação atualizada com sucesso!</div>";
        header("Refresh:4; url=http://localhost/malpatech/cadastro_pontuacao.php");

    } catch (Exception $e) {
        $conn->rollback();
        echo "<div class='alerta-erro'>Erro: " . $e->getMessage() . "</div>";
    } finally {
        $stmt->close();
        $conn->close();
    }
}
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastrar Pontuação</title>
    <link rel="stylesheet" href="style.css">
    <link rel="icon" href="https://i.imgur.com/aPo7lm8.png" type="image/x-icon">
    <script>
        function delayRedirect(url) {
            setTimeout(function() {
                window.location.href = url;
            }, 2000); 
        }
    </script>
</head>
<body>
    <div class="form-container">
        <button class="logout-button" onclick="delayRedirect('index.html')">Sair</button>
        <h1>Cadastrar Pontuação</h1>
        <form method="post" action="cadastro_pontuacao.php">
            <label for="id">Cliente:</label>
            <select id="id" name="id" required>
                <?php echo implode("\n", $clientes_options); ?>
            </select>
            <label for="tipo">Tipo de Resíduo:</label>
            <select id="tipo" name="tipo" required>
                <option value="Aluminio">Aluminio</option>
                <option value="Pilha">Pilha</option>
                <option value="Bateria">Bateria</option>
                <option value="Celular">Celular</option>
                <option value="Outros">Outros</option>
            </select>
            <label for="quantidade">Quantidade (em kg ou unidades):</label>
            <input type="number" id="quantidade" name="quantidade" step="0.01" required>
            <label for="data">Data da Doação:</label>
            <input type="date" id="data" name="data" required>
            <button type="submit" class="button">Cadastrar</button>
        </form>
    </div>

    <style>
        .logout-button {
            position: absolute;
            top: 10px;
            left: 10px;
            padding: 10px 20px;
            background-color: #06203b;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .logout-button:hover {
            background-color: #06203b;
        }
    </style>
</body>
</html>
