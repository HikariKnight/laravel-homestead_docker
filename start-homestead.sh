#!/bin/bash
DIR=$(dirname $0)
REALDIR=$(readlink -f $DIR)
SITE="site"
DGID=$(sed -nr "s/^docker:x:([0-9]+):.*/\1/p" /etc/group)

# If we have a parameter passed
if [ $# -ge 1 ]
    then
        printf "Setting default site to $1\n"

        # Set the site to the passed value
        SITE="$1"
    else
        printf "No site specified, using default name \"$SITE\" as project name.\n"
fi

printf "Starting the non persistent docker container (everything persistent is in /www)
Docker container ID: "

# Run the docker container
docker run -dit --rm --name laravel-dev -p 8000-8010:8000-8010 -v "$REALDIR/html":/www --user 0:$DGID laravel-homestead "$SITE"
printf "
You can now access the laravel-homestead site at http://127.0.0.1:8000
and you can find the files for it located under:
$REALDIR/html/$SITE

If you need access to the running container shell, run:
    docker exec -it laravel-dev bash

To stop the container you run:
    docker container stop laravel-dev
"
