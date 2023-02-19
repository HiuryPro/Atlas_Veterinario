<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

try {

    $lista = json_decode($_POST["lista"]);
    $querySt = $_POST['query'];

    $statement = $pdo->prepare($querySt);


    for ($i = 0; $i < count($lista); $i = $i + 1) {
        $statement->bindParam($i + 1, $lista[$i]);
    }

    $statement->execute();

    echo "funfa";
} catch (Exception $e) {
    echo "Erro ao cadastrar! " . $e;
}
