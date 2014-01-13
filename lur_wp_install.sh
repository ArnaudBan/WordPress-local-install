#!/bin/bash

## Les fonctions ###############################################################

# Affichage de l'aide
function help(){
  # On ne peut rien faire sans le nom du projet
  echo "LUR WordPress Installer - Installer ou créer en une ligne votre projet WordPress en local"
  echo ""
  echo "Pour l'utiliser il faut entrer comme paramétre le nom du projet qui dois correspondre au dépot gitolite"
  echo "    $0 project_name"
}

# INstalation de WordPress grâce a wp-cli
function install_wordpress(){

  # On install et parametre wordpress
  wp core download --locale=fr_FR

  wp core config --dbname=wp_$PROJECT_NAME --dbuser=$DBUSER --dbpass=$DBPASS

  wp db create

  wp core install --url=$WP_URL --title=$PROJECT_NAME --admin_email=$ADMIN_EMAIL --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD

}

# Compass init bien comme il faut
function compass_init(){
  mkdir -p compass/compass

  cd compass

  #J'arrive pas a gérer l'indentation alors il n'y en a pas
  cat << _EOF_ > compass/screen.scss
/*
* $PROJECT_NAME
* Feuille de style principale
*
*/

// Inclusions génériques ------------------------------------------------------

@import "compass/reset";

_EOF_

  compass init --prepare --sass-dir compass --css-dir ../web/wp-content/themes/$PROJECT_NAME/stylesheets --images-dir ../web/wp-content/themes/$PROJECT_NAME/stylesheets/images --javascripts-dir ../web/wp-content/themes/$PROJECT_NAME/js

}

# Init du theme
function init_wp_theme(){
  mkdir wp-content/themes/$PROJECT_NAME

  # Fichier style
  cat << _EOF_ > wp-content/themes/$PROJECT_NAME/style.css
/*
 * Theme Name: Thème $PROJECT_NAME
 * Theme URI: [[ Adresse du site, ex : http://silverwood.fr/ ]]
 * Description: [[ Descriptif du thème : Thème sur mesure pour silverwood.fr. ]]
 * Version: 1.0
 * Author: Eluère & associés
 * Author URI: http://www.eluere.com/
 * Tags: [[ Nom du client, ex: silverwood ]], Eluère, wordpress
 *
 * @package    [[ Adresse du site, ex : silverwood.fr.]]
 * @subpackage wordpress theme
 *
 */
_EOF_


  # Fichier index
  cat << _EOF_ > wp-content/themes/$PROJECT_NAME/index.php
<?php
/*
 *  $PROJECT_NAME
 *
 */

echo "Au boulot !";
_EOF_
}

## Le script ###################################################################

# On test si le seul argument est présent
if [ $1 ]; then
  # On récupére notre fichier de config
  BASEDIR=$(dirname $0)
  CONFIG_FILE=$BASEDIR/config.conf

  if [[ -f $CONFIG_FILE ]]; then
          . $CONFIG_FILE
  fi

  # On crée nos variables
  PROJECT_NAME="$1"
  WP_URL="$PROJECT_NAME.local"
  WP_DIR="$WORK_DIR$PROJECT_NAME"
  WP_WEB_DIR="$WORK_DIR$PROJECT_NAME/web"


  # On crée notre dossier
  cd $WORK_DIR
  mkdir $WP_DIR

  # On regarde si notre projet existe ou non
  cd $GITOLITE_DIR

  git pull

  # On vérifie qu'on a bien le fichier de config de gitolite
  if [[ ! -f conf/gitolite.conf ]];
  then
    echo 'Il manque les fichier de config de Gitolite'
    exit 1
  fi

  if grep -Fq "$PROJECT_NAME" conf/gitolite.conf
  then # Notre projet existe

    # On récupére notre projet gitolite
    cd $WP_DIR
    git clone alwaysdata_gitolite:$PROJECT_NAME .

    # Si il y a un dossier web on travail dedans
    if [ -d web ];
    then
      cd web
    else
      WP_WEB_DIR=$WP_DIR
    fi

    install_wordpress

  else # Notre projet n'existe pas

    # On crée notre depot
    echo -e "\nrepo \t$PROJECT_NAME \n\tRW+ \t= \t@dev \n\tR \t= \t@srv \n\tR \t= \t@deploy" >> conf/gitolite.conf

    git commit -am "Ajout du depot \"$PROJECT_NAME\""

    git push origin master

    # On crée notre projet
    cd $WP_DIR
    git clone alwaysdata_gitolite:$PROJECT_NAME .

    compass_init

    #cd web
    cd $WP_WEB_DIR
    install_wordpress

    # On initialise notre theme
    init_wp_theme

    wp theme activate $PROJECT_NAME

    cd $WP_DIR

# Git ignore
  cat << _EOF_ > .gitignore
# Ignore everything in the root except the "wp-content" directory.
/web/*
!.gitignore
!web/wp-content/

# Ignore everything in the "wp-content" directory, except the "themes" directories.
web/wp-content/*
!web/wp-content/themes/

# Ignore everything in the "themes" directory, except the themes you
web/wp-content/themes/*
!web/wp-content/themes/$PROJECT_NAME/

#ignore compass cache
/compass/.sass-cache
_EOF_

  git add *
  git add .gitignore

  git commit -m 'init'

  git push -u origin master

  fi

  if [ -d /etc/apache2/sites-available ];
  then
    # On crée le virtual host
    (sudo sh -c "echo '\n<VirtualHost *:80>
       DocumentRoot \"$WP_WEB_DIR\"
       ServerName $WP_URL
       ServerAlias $WP_URL
       <Directory \"$WP_WEB_DIR\">
           Options FollowSymLinks
           AllowOverride All
       </Directory>
      ErrorLog /var/log/apache2/$PROJECT_NAME.error.log
      CustomLog /var/log/apache2/$PROJECT_NAME.access.log combined
    </VirtualHost>
    ' >> /etc/apache2/sites-available/$PROJECT_NAME")

    #On active le site
    (sudo sh -c "a2ensite $PROJECT_NAME")
  else
    # On crée le virtual host
    (sudo sh -c "echo '\n<VirtualHost *:80>
       DocumentRoot \"$WP_WEB_DIR\"
       ServerName $WP_URL
       ServerAlias $WP_URL
       <Directory \"$WP_WEB_DIR\">
           Options FollowSymLinks
           AllowOverride All
       </Directory>
      ErrorLog /var/log/apache2/$PROJECT_NAME.error.log
      CustomLog /var/log/apache2/$PROJECT_NAME.access.log combined
    </VirtualHost>
    ' >> /etc/apache2/vhosts.d/$PROJECT_NAME.conf")
  fi



  (sudo sh -c "apachectl restart")

  (sudo sh -c "echo '\n127.0.0.1 $WP_URL' >> /etc/hosts" )

  echo "$PROJECT_NAME crée à l'adresse : $WP_URL"
  exit 0
else
  # Si il n'y a pas de nom de projet on affiche notre petite aide
  help
  exit 1
fi
