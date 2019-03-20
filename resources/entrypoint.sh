#!/bin/bash
set -e

# Export the PATH we would otherwise have from .bashrc
export PATH="~/.composer/vendor/bin:$PATH"

# Set a default value for site
site="site"

# If we have a parameter passed
if [ $# -ge 1 ]
    then
        # Set the site to the passed value
        site="$1"
fi

# Check if the site exists and take the apropriate action
if [ "$(ls -A /www/$site)" ]; then

    # Set permissions so host can edit
    chown -R $(id -u):$(id -g) /www
    chmod -R g+w /www

    # Start the php development server for the site specified
    php "/www/$site/artisan" serve --host=0.0.0.0
else
    # cd to /www
    cd "/www"

    # Make a new laravel project for the passed site
    laravel new "$site"
    
    # Set permissions so host can edit
    chown -R $(id -u):$(id -g) /www
    chmod -R g+w /www

    # Start the php development server for the site specified
    php "/www/$site/artisan" serve --host=0.0.0.0
fi
