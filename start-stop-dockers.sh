#--------------------------------------------------------------

#!/bin/bash

CONTAINERS=(
  portainer
)

for c in "${CONTAINERS[@]}"; do
  docker stop "$c"
done

#--------------------------------------------------------------


#!/bin/bash

CONTAINERS=(
  portainer
)

for c in "${CONTAINERS[@]}"; do
  docker start "$c"
done
