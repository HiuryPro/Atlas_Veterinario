<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
//(data_saida BETWEEN STR_TO_DATE('".$dedata." ', \"%d/%m/%Y\") AND STR_TO_DATE('" $atedata " ', \"%d/%m/%Y\")) ORDER BY data_saida";



$makeQuery = $_POST['query'];
$statement = $pdo->prepare($makeQuery);
$statement->execute();
$myarray = array();
$myarray2 = array();

$statement->setFetchMode(PDO::FETCH_ASSOC);


while ($resultsFrom = $statement->fetch()) {

    array_push(
        $myarray,
        $resultsFrom

    );
}


echo json_encode($myarray);
