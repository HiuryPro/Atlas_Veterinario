<?php
$myfile = fopen("vet/newfile.txt", "r") or die("Unable to open file!");
echo fread($myfile, filesize("vet/newfile.txt"));