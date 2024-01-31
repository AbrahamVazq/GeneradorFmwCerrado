#!/bin/bash
#
#XC Generator version 1.5.0 , NS-Bionick and RobinTim software.
#Copyright (C) 2022-2023 NS-Bionick Development Team
#Update 30-01-2024

schema=""
bold=$(tput bold)
normal=$(tput sgr0)
confirm=$(cat ~/.xcConfirm.txt)
title=$(cat ~/XCGenLogo.txt)
# COLORS 
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[92m'
RED_SUB='\033[101m'
L_CYAN='\033[96m'
CYAN='\033[46m'
YELLOW='\033[93m'
PURPLE='\033[35m'
BLUE='\033[34m'

clear

echo -e "${BLUE}$title${NC}"
echo ""

echo -e "${bold}IMPORTANTE${nomal}, antes de continuar verifica que cumplas todas las dependencias del Schema\n hay librerias o xcframeworks que su schema necesita."
echo -e "\nHas cumplido todas las dependencias necesarias? ( S / N ): "

read -r answer

if [[ "${#answer}" -eq 1  && ("$answer" == "S" || "$answer" == "s" || "$answer" == "N" || "$answer" == "n" ) ]]
then
      if [[ $answer == "N" || $answer == "n" ]]
      then
         echo -e "Por favor, reivsa que no falte algun XCFramework en tu producto, o alguna libreria \n generalmente MyPayments falta\n\n."
         exit
      else
         echo -e "\n\n ·-= Cual ${bold}xcframework ${normal}vamos a generar? =-·

         ${L_CYAN}1) Noticias
         2) Autobuses
         3) Total Play${NC}"

         read xc

         case $xc in
         1 )
            schema="GSSAMyNews"
         ;;
         2 )
            schema="GSSABusTickets"
         ;;
         3 )
            schema="GSSATotalPlay"
         ;; 
         * )
         echo -e "${CYAN}${bold}Pon atencion a las instrucciones todo ciego!!!"
         exit
         ;;
         esac

         cd ~/Documents/BazSuperApp/GitLab/GSSASuperApp-iOS

         if [[ -d ~/Desktop/XCFrameworks_${schema} ]]
         then
            if test -e ~/Desktop/XCFrameworks_${schema}/* ; then
               rm -R ~/Desktop/XCFrameworks_${schema}/*
            fi
         else
            mkdir ~/Desktop/XCFrameworks_${schema}
         fi

         echo "  Creando el xcframework de ${bold}>> ${schema} <<"
         echo "  Creando el Archive para Simulador  "
         echo -e "${PURPLE}${bold} "
         ############################ X C · G E N E R A T E ############################
         xcodebuild archive \
         -scheme ${schema} \
         -archivePath ~/${schema}-iphonesimulator.xcarchive \
         -sdk iphonesimulator \
         SKIP_INSTALL=NO  >> ~/${schema}-Simulador.txt

         if [[  ! -z $(grep 'SUCCEEDED' ~/${schema}-Simulador.txt ) ]]
         then
            rm -R ~/${schema}-*.txt
            echo -e "${NC}"
            echo -e "${BLUE}${bold}"
            echo "  Creando el Archive para dispositivo fisico"
            xcodebuild archive \
            -scheme ${schema} \
            -archivePath ~/${schema}-iphoneos.xcarchive \
            -sdk iphoneos \
            SKIP_INSTALL=NO >> ~/${schema}-Dispositivo.txt

            if [[ ! -z $(grep 'SUCCEEDED' ~/${schema}-Dispositivo.txt ) ]]
            then
                  rm -R ~/${schema}-*.txt
                  echo "   Armando el xcframework ... un segundo"
                  xcodebuild -create-xcframework \
                  -framework ~/${schema}-iphonesimulator.xcarchive/Products/Library/Frameworks/${schema}.framework \
                  -framework ~/${schema}-iphoneos.xcarchive/Products/Library/Frameworks/${schema}.framework \
                  -output ~/Desktop/XCFrameworks_${schema}/${schema}.xcframework
                  echo -e "${GREEN}${bold}$confirm"
                  open ~/desktop/XCFrameworks_${schema}
            else
                  echo -e "${CYAN}${bold}ALGO OCURRIO EN GENERACION DE DISPOSITIVO, REVISA QUE LAS DEPENDENCIAS EN LIBRERIAS SEAN CORRECTAS"
                  mv ~/${schema}-Dispositivo.txt  ~/${schema}-DispositivoError_$(date +%Y-%m-%d_%H:%M:%S).txt
            
            fi
         else
            echo -e "${CYAN}${bold}ALGO OCURRIO EN GENERACION DE SIMULADOR, REVISA QUE LAS DEPENDENCIAS EN LIBRERIAS SEAN CORRECTAS"
            mv ~/${schema}-Simulador.txt  ~/${schema}-SimuladorError_$(date +%Y-%m-%d_%H:%M:%S).txt
            exit
         fi

         echo -e "Ahora, limpiaremos los archivos incesarios, hasta pronto!"
         rm -R ~/${schema}-*.*
         exit
      fi
else 
      echo -e "Por favor ingresa: N o Y para No o Si. "
      exit
fi

# TO-DO:
# Agregar una animacion y saber donde pararla
