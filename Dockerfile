FROM debian:latest

EXPOSE 8000-8010/tcp
EXPOSE 3306/tcp

RUN export DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install -y \
apt-transport-https \
ca-certificates \
wget \
gnupg2 \
nano \
unzip \
htop \
bash-completion \
curl \
sudo \
git \
lsb-release \
software-properties-common \
dirmngr

RUN export DEBIAN_FRONTEND=noninteractive && \
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list && \
/bin/bash -c "debconf-set-selections <<< 'mariadb-server-10.3 mysql-server/root_password password ""'" && \
/bin/bash -c "debconf-set-selections <<< 'mariadb-server-10.3 mysql-server/root_password_again password ""'" && \
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 && \
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 8C718D3B5072E1F5 && \
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.homelab.no/mariadb/repo/10.3/debian stretch main' && \
apt-get update && apt-get install -y \
php7.3-cli \
php7.3-common \
php7.3-curl \
php7.3-mbstring \
php7.3-mysql \
php7.3-xml \
php7.3-bcmath \
php7.3-json \
php7.3-zip \
mariadb-server && \
printf '[mysqld]\nport = 3306\nbind-address = 0.0.0.0\n' >> /etc/mysql/mariadb.conf.d/50-server.cnf && \
/etc/init.d/mysql restart && \
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
sudo mv composer.phar /usr/local/bin/composer

RUN composer global require "laravel/installer" && \
echo "export PATH=\"~/.composer/vendor/bin:\$PATH\"" >> ~/.bashrc && \
echo "umask ug=rw,o=r" >> ~/.bashrc && \
umask ug=rw,o=r && \
mkdir /www && \
cd /www && \
composer create-project laravel/laravel ./site

WORKDIR /www

COPY resources/entrypoint.sh /usr/bin

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

CMD [ "site" ] 

