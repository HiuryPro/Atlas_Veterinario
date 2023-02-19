<?php


$banco = 'stocker';
$host = 'localhost';
$usuario = 'root';
$senha = '';


date_default_timezone_set('America/Sao_Paulo');

try {
	$pdo = new PDO("mysql:dbname=$banco; host=$host;charset=utf8", "$usuario", "$senha");
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
	echo "Erro ao conectar com o banco de dados! " . $e;
}
