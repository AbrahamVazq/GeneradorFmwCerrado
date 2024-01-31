#! /bin/bash
base64 -d <<< "$(<XCGenerator.txt)" | bash

# To-do
# recibir como parametro el nombre del script.sh para armar el archivo de texto
# para despues ejecutar el .x 
# armar un RSA para el resultado del .txt