set -x

if [ -z "$(which redis)" ]; then
  sudo apt-get -qq update
  sudo apt-get -qq install -y redis-server
  sudo ufw allow 6379
  
fi

if [ $(service redis-server status | grep -c running) != 1]; then
  echo 'error'
  exit 1
fi

sudo sed -i -E 's/(bind) ([0-9.]+) (::1)/\1 0.0.0.0 ''/' /etc/redis/redis.conf
sudo sed -i -E 's/#? (requirepass) (foobared)/\1 hongduy/' /etc/redis/redis.conf
sudo sed -i -E 's/#? (masterauth) (<master-password>)/\1 hongduy/' /etc/redis/redis.conf

sudo service redis-server restart
