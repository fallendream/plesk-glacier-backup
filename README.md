PLESK 11 Backup to Amazon Glacier
=================================

This small Bash script will do a Plesk Panel 11 full backup, transfer to Amazons Glacier Service and then email all the important data (archive id) to an email adress on another server for reference.
It uses the [glacieruploader](https://github.com/MoriTanosuke/glacieruploader) to do the heavy lifting.

Prerequisites
-------------------------

In order to do the backup and use the script you need to have the following:

* [Amazon Glacier account](http://aws.amazon.com/glacier/) - keep in mind that using such an account will lead to expenses. See the price page for more information.
* [Plesk PANEL 11](http://www.parallels.com/de/download/plesk/), it may work in older versions but it was not tested on them.
* Java Virtual machine, since the uploader is a Java program.

Installation
-------------------------

0. Make sure all the prerequsites are met (install a Java VM!).
1. The let the script work automatic backups of the plesk must be activated. Its perfectly ok do hold back only one back up on the server repository, but one backup must exist at last to be picked up by the script. As an admin go to the Plesk Panel -> Tools & Settings -> Backup Manager -> Schedule a full server backup. Do it as often as you like but time it so that at least one plesk backup is created prior of running a upload job via this script.
2. Copy the src folder content anywhere on your server.
3. Check if the backup-script has the execute flag set. It should be set to readonly by root aswell to prevent other users to read the variable settings of the script. So issue a `chown root:root remote-create-backup.sh` and `chmod 700 remote-create-backup.sh` do the same for the aws.properties file.
3. Edit remote-create-backup.sh and replace all the needed variables.
4. Edit aws.properties file and fill in the access key and the secret key provided by Amazon.
4. Create a root cron job to call the script. Do it as often as you like. The script must be run as root otherwise the plesk backup can not be performed. You can edit your sudoer file to allow any user to call the script. The cron can be created via plesk Tools & Settings -> Scheduled Tasks -> Look for root user and enter the path to the backup script.


Usage
-------------------------

The script must be run as root because the backup of plesk must be done as root. Only allowing the plesk backup ultility with the sudo file will not work either since the script must delete the created backup file afterwards which then will be owned by root and thus can not be deleted by the (not as root running) script. So I advise to simply run the script as the root user. This will get rid of these problems.



Licence
-------------------------

The script itself is licenced with the BSD-Licence, see LICENCE.

This software contains parts which are under [GNU GPL v3](http://www.gnu.org/licenses/gpl-3.0.en.html) (the Java Amazon AWS library, its sources can be obtained under: [glacieruploader](https://github.com/MoriTanosuke/glacieruploader)).

Brought to you by [FALLENDREAM](http://www.fallendream.com).