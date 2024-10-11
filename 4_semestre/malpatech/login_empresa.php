<?php
// Conectar ao banco de dados
$conn = new mysqli("localhost", "root", "", "BD_Malpa");

if ($conn->connect_error) {
    die("Erro na conexão com o banco de dados: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $CNPJ = $_POST["CNPJ"];
    $senha = $_POST["senha"];

    // Verificar se o cnpj corresponde a um usuário no banco de dados
    $sql = "SELECT * FROM empresa WHERE CNPJ = '$CNPJ'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $senha_armazenada = $row["senha"];

        // Verificar se a senha corresponde (usando password_verify)
        if (password_verify($senha, $senha_armazenada)) {
            session_start();
            $_SESSION["CNPJ"] = $CNPJ;
            header("Location: pagina_empresa.php"); // Redirecionar para a página de dashboard
        } else {
            echo "Senha incorreta.";
        }
    } else {
        echo "CNPJ não encontrado.";
    }
}

// Fechar a conexão
$conn->close();
?>
