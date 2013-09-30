#!/bin/bash

function help(){
  # On ne peut rien faire sans le nom du projet
  echo "LUR WordPress Installer - Installer ou créer en une ligne votre projet WordPress en local"
  echo ""
  echo "Pour l'utiliser il faut entrer comme paramétre le nom du projet qui dois correspondre au dépot gitolite"
  echo "    $0 project_name"
}

# test the number of arguments
if [ $1 ]
then
  # On récupére notre fichier de config
  CONFIG_FILE=$PWD/config.conf

  if [[ -f $CONFIG_FILE ]]; then
          . $CONFIG_FILE
  fi

  # On crée nos variables
  PROJECT_NAME="$1"
  WP_URL="$PROJECT_NAME.local"
  WP_DIR="$WORK_DIR$PROJECT_NAME"

  # On crée notre dossier
  mkdir $WP_DIR ;cd $WP_DIR

  # On crée un dépot git
  git init

  # On install et parametre wordpress
  wp core download --locale=fr_FR

  wp core config --dbname=wp_$PROJECT_NAME --dbuser=$DBUSER --dbpass=$DBPASS

  mysqladmin -u $DBUSER -p$DBPASS create wp_$PROJECT_NAME

  wp core install --url=$WP_URL --title=$PROJECT_NAME --admin_email=$ADMIN_EMAIL --admin_password=$ADMIN_PASSWORD

  # TODO le créer si il n'existe pas

  # On récupére notre projet gitolite
  git remote add origin alwaysdata_gitolite:$PROJECT_NAME

  git pull origin master

  # On crée le virtual host
  (sudo sh -c "echo '\n<VirtualHost *:80>
     DocumentRoot \"$WP_DIR\"
     ServerName $WP_URL
     ServerAlias $WP_URL
     <Directory \"$WP_DIR\">
         Options FollowSymLinks
         AllowOverride All
     </Directory>
  </VirtualHost>
  ' >> /etc/apache2/extra/httpd-vhosts.conf")

  (sudo sh -c "apachectl restart")

  (sudo sh -c "echo -e '\n127.0.0.1 $WP_URL' >> /etc/hosts" )

  echo "$PROJECT_NAME crée à l'adresse : $WP_URL"
else
  # Si il n'y a pas de nom de projet on affiche notre petite aide
  help
fi