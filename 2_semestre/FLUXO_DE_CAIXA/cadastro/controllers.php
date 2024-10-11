<?php
require_once '../cadastro/models.php';
if(isset($_POST['nome'])){

    $nome = $_POST['nome'];
    $senha = $_POST['senha'];
    
    $login = new login();


    $login->setNome($nome);
    $login->setSenha($senha);
    
    
    $login->insert($nome, $senha,);
}