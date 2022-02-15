# Automation_Project

Checks if apache2 is installed and enabled.

If not script installs and enables the service.

tar all the log files from /var/log/apache2/ to /tmp

And copy tar file to S3 bucket.

Do bookkeeping of archiving in inventory.html.

Script will add a cronjob to run the script if not existing.
