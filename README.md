# ipcheck-set-ufw-rule
Shell script to update your UFW Firewall Rule to allow port 22 (SSH) (or other ports) with your Home Dynamic IP Address.

# Usage:

1. Pull up a terminal or SSH into the target server.

2. Logon as root

<code>sudo -i</code>

3. Download the installer script.

```
wget https://raw.githubusercontent.com/clusterednetworks/ipcheck-set-ufw-rule/master/ipcheck_set_ufw_rule.sh
```

4. Make the script executable

```
chmod +x ipcheck_set_ufw_rule.sh
```

5. Run the script.

```
./ipcheck_set_ufw_rule.sh [change to your dynamic dns record] 22 tcp
```
e.g ./ipcheck_set_ufw_rule.sh server01.duckdns.com 22 tcp

e.g 2 ./ipcheck_set_ufw_rule.sh server01.duckdns.com 8443 tcp

6. Setup a cronjob to run the script every 5 min if you choose.
   
```
*/5 * * * * /etc/ipcheck_set_ufw_rule.sh [your dynamic dns a record] 22 tcp >/dev/null 2>&1
```

