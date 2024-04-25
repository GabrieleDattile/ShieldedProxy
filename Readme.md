# ShieldedProxy

Accesso proxy pubblico sicuro

## SSHProxyGuard

SSHProxyGuard è uno script Bash per avviare e gestire in modo sicuro tunnel SSH per l'utilizzo di proxy pubblici.

## Descrizione

Questo script permette agli utenti di utilizzare proxy pubblici in modo sicuro attraverso tunnel SSH. Può essere utile per coloro che desiderano sfruttare proxy pubblici per varie attività online, come navigare in modo anonimo o accedere a contenuti geograficamente limitati, senza compromettere la propria sicurezza.

## Utilizzo

Assicurarsi di avere i requisiti seguenti prima di utilizzare lo script:

- Accesso a un server SSH remoto.
- Configurazione di proxy pubblici accessibili tramite tunnel SSH.

Per utilizzare lo script:

1. Modificare le variabili nel file `ssh_proxy_guard.sh` con le proprie credenziali SSH e le impostazioni del proxy.
2. Assicurarsi che lo script sia eseguibile: `chmod +x ssh_proxy_guard.sh`.
3. Eseguire lo script: `./ssh_proxy_guard.sh`.

