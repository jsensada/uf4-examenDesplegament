#!/bin/bash

echo "Pas1: Instal·lant paquets necessaris:"
sudo apt update
sudo apt install -y nginx
sudo apt install -y python3
sudo apt install -y python3-pip
sudo apt install -y mysql-server

echo "Pas2: Creant els usuari de Linux:"
sudo groupadd app-users
sudo useradd -m -d /home/app1 -s /bin/bash app1
sudo usermod -a -G sudo app1
sudo usermod -a -G app-users app1
sudo useradd -m -d /home/app2 -s /bin/bash app2
sudo usermod -a -G sudo app2
sudo usermod -a -G app-users app2
sudo useradd -m -d /home/app3 -s /bin/bash app3
sudo usermod -a -G sudo app3
sudo usermod -a -G app-users app3

echo "Pas3: Copiant els fitxers de python necessaris:"
sudo mkdir -p /opt/app/uf4-examen
sudo cp requirements.txt /opt/app/uf4-examen/
sudo cp app1.py /opt/app/uf4-examen/
sudo cp app2.py /opt/app/uf4-examen/
sudo cp app3.py /opt/app/uf4-examen/
sudo chown -R :app-users /opt/app/uf4-examen

echo "Pas4: Instal·lant paqueteria de python (dependències pip):"
sudo pip3 install -r /opt/app/uf4-examen/requirements.txt

echo "Pas5: Configurant la base de dades pel servei 3"
FLUSH_PRIVILEGES_QUERY="FLUSH PRIVILEGES;"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS app3;"
sudo mysql -e "CREATE USER 'flaskuser'@'localhost' IDENTIFIED BY 'password' WITH MAX_USER_CONNECTIONS 1;"
sudo mysql -e "GRANT ALL PRIVILEGES ON app3.* TO 'flaskuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Pas6: Creant i habilitant els serveis de cada app:"
sudo cp app1.service /etc/systemd/system/
sudo systemctl enable app1
sudo systemctl start app1
sudo cp app2.service /etc/systemd/system/
sudo systemctl enable app2
sudo systemctl start app2
sudo cp app3.service /etc/systemd/system/
sudo systemctl enable app3
sudo systemctl start app3

echo "Pas7: Habilitant Nginx"
sudo bash -c 'echo 127.0.0.1 examen-uf4.com >> /etc/hosts'
sudo cp nginx.conf /etc/nginx/sites-enabled/default
sudo service nginx restart