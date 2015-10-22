uuidgen > /var/www/rsyncd.password
echo -n 'cyber-dojo:' > /var/www/rsyncd.secrets
cat /var/www/rsyncd.password >> /var/www/rsyncd.secrets
