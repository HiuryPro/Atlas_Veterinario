<?php

if (!is_dir('vet')) {
    //Criamos um diretório
    mkdir('vet', 0755, true);
}


$myfile = fopen("vet/newfile.txt", "w") or die("Unable to open file!");
$txt = "John Doe\n";
fwrite($myfile, $txt);
$txt = "Jane Doe\n";
fwrite($myfile, $txt);
fclose($myfile);

echo 'Escreveu';