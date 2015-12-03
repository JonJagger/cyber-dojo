
# These files on the host
sudo mkdir -p /var/www/cyber-dojo/katas/
sudo chmod g+s /var/www/cyber-dojo/katas/
sudo chown -r 33:33 /var/www/cyber-dojo/katas/

# Pull the language images you want
docker pull cyberdojofoundation/gcc_assert

# Build and run the image
docker build -t meekrosoft/cyber-dojo:1.0 .
docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
           -v /var/www/cyber-dojo/katas:/var/www/cyber-dojo/katas \
           -v /usr/local/bin/docker:/bin/docker \
           -p 80:80 -p 443:443 meekrosoft/cyber-dojo:1.0

# Refresh the cache in the container
docker exec -ti [CONTAINERID] bash
./cyber-dojo/admin_scripts/refresh_all_caches.sh
exit
