#!/bin/bash
echo "
  ░▒▓███████▓▒░▒▓███████▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓███████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓███████▓▒░░▒▓███████▓▒░  
░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
 ░▒▓██████▓▒░░▒▓██████▓▒░░▒▓████████▓▒░      ░▒▓███████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░ ░▒▓██████▓▒░       ░▒▓█▓▒▒▓███▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
       ░▒▓█▓▒░     ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░          ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
       ░▒▓█▓▒░     ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░          ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓███████▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░           ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░ 

by Gabriele D'Attile
"

# Variabili
SSH_HOST="example.com"
SSH_PORT="22"
SSH_USER="username"
PROXY_PORT="8080"
URL="http://www.example.com"
TUNNEL_CONFIG_FILE="/tmp/ssh-tunnel.conf"
LOG_FILE="/var/log/ssh-tunnel.log"

# Controlla se il proxy è in ascolto
if ! nc -z localhost $PROXY_PORT >/dev/null 2>&1; then
    echo "Errore: proxy non in ascolto sulla porta $PROXY_PORT"
    exit 1
fi

# Controlla se il file di configurazione del tunnel esiste
if [ -f "$TUNNEL_CONFIG_FILE" ]; then
    echo "Errore: il file di configurazione del tunnel esiste già"
    exit 1
fi

# Genera la chiave SSH
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -q -N "" -t rsa -f ~/.ssh/id_rsa
fi

# Avvia il tunnel SSH
echo -e "RemoteForward $PROXY_PORT localhost:$SSH_PORT\nUser $SSH_USER\nHost $SSH_HOST\nPort $SSH_PORT\nIdentityFile ~/.ssh/id_rsa" >$TUNNEL_CONFIG_FILE

# Avvia il tunnel SSH in background
ssh -fNT -o StrictHostKeyChecking=no -D $PROXY_PORT $TUNNEL_CONFIG_FILE

# Controlla il codice di uscita del comando di avvio del tunnel SSH e attendi il completamento dell'avvio
if [ $? -ne 0 ]; then
    echo "Errore: impossibile avviare il tunnel SSH"
    exit 1
fi

# Aspetta che il tunnel SSH sia stabilito
if ! timeout 30 nc -z localhost $PROXY_PORT >/dev/null 2>&1; then
    echo "Errore: impossibile connettersi al proxy"
    exit 1
fi

# Effettua la richiesta utilizzando Curl attraverso il proxy
HTTP_CODE=$(curl --socks5 localhost:$PROXY_PORT -o /dev/null -s -w "%{http_code}\n" $URL)

# Controlla il codice di risposta HTTP
if [ "$HTTP_CODE" = "200" ]; then
    echo "La richiesta HTTP è stata completata con successo (codice di risposta HTTP: $HTTP_CODE)"
else
    echo "Errore: risposta HTTP non valida (codice di risposta HTTP: $HTTP_CODE)"
    exit 1
fi

# Termina il processo SSH una volta completato
TUNNEL_PID=$(pgrep -f "ssh -fNT -o StrictHostKeyChecking=no -D $PROXY_PORT $TUNNEL_CONFIG_FILE")
if [ -n "$TUNNEL_PID" ]; then
    ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST -p $SSH_PORT "sudo pkill -f ssh"
fi

# Pulizia completa delle risorse
if [ -f "$TUNNEL_CONFIG_FILE" ]; then
    rm $TUNNEL_CONFIG_FILE
fi

# Logging
echo "Script terminato con successo" >>$LOG_FILE

# Imposta le autorizzazioni appropriate per il file di log
chown $USER:$USER $LOG_FILE
chmod 600 $LOG_FILE

# Monitoraggio dei processi SSH
PID_LIST=$(pgrep -f "ssh -fNT -o StrictHostKeyChecking=no -D $PROXY_PORT $TUNNEL_CONFIG_FILE")

# Se non esiste alcun processo SSH, interrompi lo script
if [ -z "$PID_LIST" ]; then
    echo "Errore: impossibile monitorare i processi SSH"
    exit 1
fi

# Monitora i processi SSH ogni 5 secondi
while true; do
    sleep 5

    # Se il processo SSH non esiste più, interrompi lo script
    PID_LIST=$(pgrep -f "ssh -fNT -o StrictHostKeyChecking=no -D $PROXY_PORT $TUNNEL_CONFIG_FILE")
    if [ -z "$PID_LIST" ]; then
        echo "Errore: impossibile monitorare i processi SSH"
        exit 1
    fi
done
