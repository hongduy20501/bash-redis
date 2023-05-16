set -x
if [ -z "$(which redis)" ]; then
  sudo apt-get -qq update
  sudo apt-get -qq install -y redis-server
  sudo ufw allow 6379

fi

sudo apt-get -qq update
sudo apt-get -qq install -y redis-sentinel

if [ $(service redis-sentinel status | grep -c running) != 1 ]; then
  echo "error"
  exit 1
fi

sudo systemctl enable redis-sentinel

sudo sed -i -E 's/(bind) ([0-9.]+) (::1)/\1 0.0.0.0 ''/' /etc/redis/redis.conf
sudo sed -i -E 's/(bind) ([0-9.]+) (::1)/\1 0.0.0.0 ''/' /etc/redis/sentinel.conf
sudo sed -i -E 's/#? (sentinel monitor) .*/\1 redis-master 10.207.127.170 6379 2/' /etc/redis/sentinel.conf
sudo sed -i -E 's/#? (sentinel down-after-milliseconds) (<master-name>) (<milliseconds>)/\1 redis-master 1500/' /etc/redis/sentinel.conf
sudo sed -i -E 's/#? (sentinel failover-timeout) (<master-name>) (<milliseconds>)/\1 redis-master 3000/' /etc/redis/sentinel.conf

sudo service redis-sentinel restart
