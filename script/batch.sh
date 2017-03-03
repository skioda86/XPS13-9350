#!/bin/zsh

file="~/Scrivania/errori.txt"

# Funzione per riavviare shell di GNOME
function riavviaShell {
	echo "RIAVVIO SHELL"	
	gnome-shell -r 2> ~/Scrivania/errori.txt &
	sleep 5	
	echo "SHELL RIAVVIATA"	
}


function riavvioControllato {
if [ -e $file ]; then
		rm ~/Scrivania/errori.txt
	else
		errore=1
		riavviaShell
		while [ $errore -eq "1" ]; do		
			cat ~/Scrivania/errori.txt | grep CRITICAL			
			if [ $? -eq "0" ]; then
				echo "!!!!!!!!Trovato errore CRITICAL!!!!!!!!!"
				riavviaShell
				errore=1
			else
				rm ~/Scrivania/errori.txt 		
				echo "SHELL FUNZIONANTE"
				errore=0
			fi
		done
	fi

}






 
# Controllo se GNOME si è avviato correttamente
# analizzando se il file /usr/bin/gnome-shell
# contiene errori CRITICAL
journalctl /usr/bin/gnome-shell | tail | grep -i -e 'error' -e 'failed'
if [ $? -eq "0" ]; then
	riavvioControllato	
fi


