<?php
session_start();
set_time_limit(0);

$pagina_login = 1;

include 'config.php';
include 'functions.php';

if (isset($_GET['sair'])) {
    $_SESSION['logado'] = "";
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <link rel="preload" href="" as="font" type="" crossorigin>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title id='titulo'> <?php echo $lc_titulo ?></title>
        <meta name="LANGUAGE" content="Portuguese" />
        <meta name="AUDIENCE" content="all" />
        <meta name="RATING" content="GENERAL" />
        <script language="javascript" src="scripts.js"></script>
        <div class="font-container" style="font-family: 'arial'; font-weight: normal; font-style: normal;">
        <link href="estilo.css" rel="stylesheet" type="text/css" />
        <link rel="icon" href="images/fintechicone.png>
    </head>
    <body class="bg">
        <center>
        <img src = "./images/logo.png" width ="450">
        </center>
        </table>
        <br />
        <table cellpadding="10" cellspacing="5"  width="920"  align="center" >

            <tr>
                <td colspan="11" align="center" >
                    Faça Login para entrar:
                    <br><br>
                            <form action="" method="post">
                                Login: <input type='text' name= 'login' ><br>
                                        Senha: <input type='password' name='senha'><br>
                                                <br>
                                                    <input type='submit' name='OK' value='Entrar'>
                                                        </form>
                                                        <br>
                                                        <a href=cadastro/insert.php ><strong> cadastrar</strong></a>
                                                        <br>
                                                            </td>
                                                            </tr>
                                                            </table>
                                                            <table cellpadding="5" cellspacing="0" width="900" align="center">
                                                               
                                                            </body>
                                                            </html>
