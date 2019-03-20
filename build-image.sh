#!/bin/bash
DIR=$(dirname $0)
REALDIR=$(readlink -f $DIR)
docker build -t laravel-homestead $DIR
printf "
You can now make a laravel container using the below command and access the site at http://127.0.0.1:8000
\tdocker run -dit --name laravel-dev -p 8000-8010:8000-8010 -v $REALDIR/html:/www --user $(id -u):$(id -g) laravel-homestead

\tNOTE: you can pass a project name at the end of the command to use as a 
\tdefault laravel project each time it is started in the future (default: site)

To start the container in the future after it's creation run
\tdocker container start laravel-dev

To reach the shell of a the container once it has started you need to run
\tdocker exec -it laravel-dev bash
"
