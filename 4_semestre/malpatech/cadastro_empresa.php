<?php
// Conectar ao banco de dados
$servername = "localhost"; // Endereço do servidor MySQL
$username = "root"; // Nome de usuário do MySQL
$password = ""; // Senha do MySQL
$dbname = "BD_Malpa"; // Nome do banco de dados

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Receba os dados do formulário
    $nome_empresa = $_POST["nome_empresa"];
    $CNPJ = $_POST["CNPJ"];
    $email = $_POST["email"];
    $senha = password_hash($_POST["senha"], PASSWORD_DEFAULT);
    $categoria = $_POST["categoria"];

    // Prepare e execute a declaração
    $stmt = $conn->prepare("INSERT INTO empresa (nome_empresa, cnpj, email, senha, categoria) VALUES (:nome_empresa, :CNPJ, :email, :senha, :categoria)");
    $stmt->bindParam(':nome_empresa', $nome_empresa);
    $stmt->bindParam(':CNPJ', $CNPJ);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':senha', $senha);
    $stmt->bindParam(':categoria', $categoria);
    $stmt->execute();

    echo "Cadastro realizado com sucesso!";
    header("Location: login.html");
} catch (PDOException $e) {
    echo "Erro no cadastro: " . $e->getMessage();
}

// Feche a conexão
$conn = null;
?>
