<?php
exec('wmic COMPUTERSYSTEM Get UserName', $user);
$dir = 'C:\Users\Hiury G\Downloads\usado2';


//Verificamos se o diretório não existe

if (!is_dir($dir)) {
    //Criamos um diretório
    mkdir($dir, 0755, true);
}


echo ($dir);
echo ("<br/>");