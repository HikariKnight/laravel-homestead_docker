FROM debian:latest

EXPOSE 8000-8010/tcp

RUN apt-get update && apt-get install -y \
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
git && \
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list && \
apt-get update && apt-get install -y \
php7.3-cli \
php7.3-common \
php7.3-curl \
php7.3-mbstring \
php7.3-mysql \
php7.3-xml \
php7.3-bcmath \
php7.3-json \
php7.3-zip

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
sudo mv composer.phar /usr/local/bin/composer

RUN composer global require "laravel/installer" && \
echo "export PATH=\"~/.composer/vendor/bin:\$PATH\"" >> ~/.bashrc && \
mkdir /www && \
cd /www && \
composer create-project laravel/laravel ./site

WORKDIR /www

COPY resources/entrypoint.sh /usr/bin

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

CMD [ "site" ] 

