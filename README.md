# checklogin

## Description:

This solution provides email notification for logins of linux/unix system users. The script operates on a diff method of last login.

## Requirement:

* Unix/Linux server with sudo permissions, because of issues with AWS EC2 instances and IP Spam blocking this script may not work, I will make a AWS SES option in the future. 
* Unix/Linux Mail command to install the *nix Mail command see below.

* CentOS/Redhat 7/6/5
```bash
sudo yum install mailx
```

* Fedora 22+
```bash
dnf install mailx
```

* Ubuntu/Debian/LinuxMint
```bash
sudo apt-get install mailutils
```

## Setup:

```bash
git clone https://github.com/nethacker/checklogin.git

cd checklogin

sudo mkdir /var/log/logins

sudo chown youruser:youruser /var/log/logins
```

Change the email address in the script after EMAIL to send notification to.
```bash
vim checklogin.sh
```

```bash
cp checklogin.sh /var/log/logins

sudo chmod 755 /var/log/logins/checklogin.sh

crontab -e

*/5 * * * * /var/log/logins/checklogin.sh
```

### Testing / Troubleshooting

* After two login and out attempts to the server you should get an email.
* Check your spam folder it might end up there, and whitelist the email.
* The script executes every 5 minutes on a cron so you won't get an email immediately.

To check of the mail command is working on your server which the script depends on

```bash
echo -e "Test body" | mail -s 'Test Email' youremail@whatever.com
```

To check if you can see your login history

```bash
/usr/bin/last
```

