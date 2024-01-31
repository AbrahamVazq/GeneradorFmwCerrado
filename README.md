# GeneradorFmwCerrado

·-= Instalacion de SHC =-·

Se intalara el shc para poder compilar y armar un ejecutable 
En macOS instalamos shc con:

    brew install shc

Compilamos el script con 

    shc -f script.sh

Es importante que el script cuente con permisos usar

    chmod 777 script.sh

Ejecutamos con

    ./script.sh


·=- Como ofuscar el Script =-·
Usa 
    cat .XCscript.sh | base64 > script.txt   

·-= Armar el ejecutable SemiOfuscado =-·

Crea un ejecutable del script codificador, no sin antes modificarlo con el nombre del txt a leer en base 64

