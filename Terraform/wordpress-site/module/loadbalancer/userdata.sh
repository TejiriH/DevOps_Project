#!/bin/bash
# Update and install necessary utilities
yum update -y
yum install -y amazon-efs-utils wget unzip httpd

# Enable the Amazon Linux Extras repository and install PHP 7.2
amazon-linux-extras enable php8.2
yum clean metadata
yum install -y php php-mysqlnd

# Mount EFS to /var/www/html (EFS storage for WordPress)
mkdir -p /var/www/html
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_mount_command}:/ /var/www/html  # Using the EFS mount command output from Terraform

# Persist EFS mount across reboots
echo "${efs_id}:/ /var/www/html nfs4 defaults,_netdev 0 0" >> /etc/fstab

# Start Apache and enable it to run on boot
systemctl start httpd
systemctl enable httpd

# Install additional PHP modules required for WordPress
yum clean metadata
yum install -y php-fpm php-mbstring php-soap php-gd php-intl php-xml php-cli php-json

# Download the latest WordPress package
wget https://wordpress.org/latest.tar.gz -P /tmp/

# Extract the WordPress package
tar -xzvf /tmp/latest.tar.gz -C /tmp/

# Copy WordPress files to EFS directory
cp -r /tmp/wordpress/* /var/www/html/

# Set proper permissions for WordPress files
chown -R apache:apache /var/www/html/

# Set up WordPress configuration file
# cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Modify wp-config.php with your MySQL DB credentials
sed -i "s/database_name_here/mysql/g" /var/www/html/wp-config-sample.php
sed -i "s/username_here/${db_user}/g" /var/www/html/wp-config-sample.php
sed -i "s/password_here/${db_password}/g" /var/www/html/wp-config-sample.php
sed -i "s/localhost/${db_host}/g" /var/www/html/wp-config-sample.php

# Restart Apache to apply changes
systemctl restart httpd

# Clean up the downloaded package
# rm -rf /tmp/latest.tar.gz /tmp/wordpress

# Create a simple index.php to check if PHP is working
# echo "<?php phpinfo(); ?>" > /var/www/html/index.php

# Ensure Apache starts on boot
systemctl enable httpd
