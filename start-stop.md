sudo nano /usr/local/bin/docker_night_stop.sh
sudo chmod +x /usr/local/bin/docker_night_stop.sh

sudo nano /usr/local/bin/docker_morning_start.sh
sudo chmod +x /usr/local/bin/docker_morning_start.sh


sudo crontab -e

0 1 * * * /usr/local/bin/docker_night_stop.sh
0 7 * * * /usr/local/bin/docker_morning_start.sh


sudo docker ps --format "table {{.Names}}\t{{.Image}}"
sudo docker ps --format "{{.Names}}" | sort