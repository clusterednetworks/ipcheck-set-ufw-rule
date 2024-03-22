# ipcheck-set-ufw-rule
Shell script to update your UFW Rule to allow port 22 (SSH) from your Home Dynamic IP Address.

# Usage:

1. Pull up a terminal or SSH into the target server.

2. Logon as root

<code>sudo -i</code>

3. Download the installer script.

```
wget https://raw.githubusercontent.com/clusterednetworks/backup-www/master/ipcheck_set_ufw_rule.sh
```

4. Make the script executable

```
chmod +x ipcheck_set_ufw_rule.sh
```

6. Run the script.

```
./ipcheck_set_ufw_rule.sh [change to your dynamic dns record] 22 tcp</code>
```
e.g ./ipcheck_set_ufw_rule.sh server01.duckdns.com 22 tcp

e.g 2 ./ipcheck_set_ufw_rule.sh server01.duckdns.com 8443 tcp

7. Setup a cronjob to run the script every 5 min if you choose.
   
```
*/5 * * * * /etc/ipcheck_set_ufw_rule.sh [your dynamic dns a record] tcp 22 >/dev/null 2>&1
```

