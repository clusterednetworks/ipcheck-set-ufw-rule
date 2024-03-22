# ipcheck-set-ufw-rule
Shell script to update your UFW Rule to allow port 22 (SSH) from your Home Dynamic IP Address.

# Usage:

1. Pull up a terminal or SSH into the target server.

2. Logon as root

<code>sudo -i</code>

3. Download the installer script.

<code>wget https://raw.githubusercontent.com/clusterednetworks/backup-www/master/ipchek_set_ufw_rule.sh</code>

4. Make the script executable

<code>chmod +x backup-www.sh</code>

6. Run the script.

<code>./ipcheck_set_ufw_rule.sh [your dynamic dns a record] 22 tcp</code>
e.g ./ipcheck_set_ufw_rule.sh server01.duckdns.com 22 tcp

7. Setup a cronjob to run the script every 5 min if you choose.
<pre>
*/5 * * * * /etc/ipcheck_set_ufw_rule.sh [your dynamic dns a record] >/dev/null 2>&1
</pre>

