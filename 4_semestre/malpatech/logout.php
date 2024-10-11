<?php
session_start();
session_destroy();
header("Location: login.html"); // Redirecionar para a página de login após o logout
?>
