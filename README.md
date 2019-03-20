# A docker for laravel-homestead
**WARNING: This docker image is meant for development and not for production hosting!**

I got an assignment which involved making something using laravel, I did not want to install laravel or any webserver on my system so I figured I would use laravel-homestead which runs inside a vagrant box on a virtualbox, vmware or xen backend.

Now this works in most cases, however I had the unique problem that my kernel was so new that the virtualbox-dkms module would not work with it yet, so I decided to try set up a laravel-homestead inside docker in order to help others which this unique problem.

First of all you will need to install docker or docker-ce for Linux<br>
https://docs.docker.com/install/

For Ubuntu 18.10 use the Test branch if Stable does not exist yet.

## Installation through https://hub.docker.com
```bash
mkdir -p devel/laravel/html
cd devel/laravel
docker run -dit --rm --name laravel-dev -p 8000-8010:8000-8010 -v "$PWD/html":/www --user 0:$(sed -nr "s/^docker:x:([0-9]+):.*/\1/p" /etc/group) hikariknight/laravel-homestead "projectname" 
```

## Installation using git

**Now just download this repository<br>**
```bash
git clone https://github.com/HikariKnight/laravel-homestead_docker.git
```
<br>

**Build the laravel-homestead image and start it**<br>

```bash
cd laravel-homestead_docker
./build-image.sh
./start-homestead.sh
```

You can now access the laravel test page at http://127.0.0.1:8000

The script "start-homestead.sh" takes 1 parameter which is the project name, the default project name is "site" but if you pass a project name after the script, it will make that project and use that for the development environment.

In order to be able to edit the project files inside the html folder, your user must be a member of the docker group on the host side, the docker install should take you through how to set that up.