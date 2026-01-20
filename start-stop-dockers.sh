sudo docker ps --format "table {{.Names}}\t{{.Image}}"

sudo nano /usr/local/bin/docker_night_stop.sh
sudo chmod +x /usr/local/bin/docker_night_stop.sh

#--------------------------------------------------------------

#!/bin/bash

CONTAINERS=(
  portainer
)

for c in "${CONTAINERS[@]}"; do
  docker stop "$c"
done

#--------------------------------------------------------------

sudo nano /usr/local/bin/docker_morning_start.sh
chmod +x /usr/local/bin/docker_morning_start.sh

#-------------------------------------------------------------

#!/bin/bash

CONTAINERS=(
  portainer
)

for c in "${CONTAINERS[@]}"; do
  docker start "$c"
done


sudo crontab -e


0 1 * * * /usr/local/bin/docker_night_stop.sh
0 7 * * * /usr/local/bin/docker_morning_start.sh