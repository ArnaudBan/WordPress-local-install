# WordPress Installer


Installer ou créer votre projet WordPress en local

## Ce que ce script fait

Ce script va récupérer ou créer un projet git pour un site WordPress en local

* Commence par regarder si le projet demandé et présent dans votre fichier gitolite
* Si le projet demandé n'est pas présent, il le rajout a votre fichier gitolite
* Récupére le depot git lié au projet demandé
* Install et configure WordPress
* Active ou crée le theme WordPress (même nom que le prejet demandé)
* Ajout le Virtual host et modifie le fichier host
* Vous donne l'URL local de votre projet (nom_du_projet.dev)


## Pré-requis

Pour fonctionner ce script a besoin de wp-cli. Installer le en suivant les instructions qui vous trouverez ici :
http://wp-cli.org/

Compass est également requis
http://compass-style.org/install/

## Configuration

Créer votre fichier de configuration en duplicant le fichier config-sample.conf et le nomant config.conf
Vous devez y paramétrer :

  * WORK_DIR="/Users/arnaud/Workspace/"                     - Le chemin complet vers votre dossier local où sont installer vos fichiers
  * GITOLITE_DIR="/Users/arnaud/Workspace/_gitolite-admin/" - Le chemin vers votre dépot local de gitolite
  * DBUSER="root"                                           - Votre nom d'utilisateur pour MySQL
  * DBPASS="root"                                           - Votre mot de passe MySQL
  * ADMIN_EMAIL="arnaud.banvillet@gmail.com"                     - L'email Admin que vous souhaitez pour vos install WordPress
  * ADMIN_USER="admin"                                      - Nom du premier utilisteur
  * ADMIN_PASSWORD="admin"                                  - Mot de passe WordPress pour votre premier utilisateur

## Utilisation

Il vous suffit de lancer la commande :

  ./lur_wp_install.sh nom_de_projet

Si nom_de_projet correspond a un dépôt présent dans gitolite Il sera puller automatiquement
Sinon il sera créer et votre thême, qui aura le même nom, sera initialisé.