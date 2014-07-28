# WordPress Installer


Installer ou créer votre projet WordPress en local

## Ce que ce script fait

Ce script va récupérer ou créer un projet git pour un site WordPress en local

* Commence par regarder si le projet demandé et présent dans votre fichier gitolite
* Si le projet demandé n'est pas présent, il le rajoute a votre fichier gitolite
* Récupére le depot git lié au projet demandé
* Installe et configure WordPress
* Active ou crée le theme WordPress (même nom que le projet demandé)
* Ajoute le Virtual host et modifie le fichier host
* Vous donne l'URL local de votre projet (nom_du_projet.dev)


## Pré-requis

Pour fonctionner ce script a besoin de wp-cli. Installez le en suivant les instructions qui vous trouverez ici :
http://wp-cli.org/

Compass est également requis
http://compass-style.org/install/

## Configuration

Créer votre fichier de configuration en duplicant le fichier config-sample.conf et le nommant config.conf
Vous devez y paramétrer :

  * WORK_DIR="/Users/arnaud/Workspace/"                     _Le chemin complet vers votre dossier local où sont installer vos fichiers_
  * GITOLITE_DIR="/Users/arnaud/Workspace/_gitolite-admin/" _Le chemin vers votre dépot local de gitolite_
  * DBUSER="root"                                           _Votre nom d'utilisateur pour MySQL_
  * DBPASS="root"                                           _Votre mot de passe MySQL_
  * ADMIN_EMAIL="arnaud.banvillet@gmail.com"                _L'email Admin que vous souhaitez pour vos install WordPress_
  * ADMIN_USER="admin"                                      _Nom du premier utilisteur_
  * ADMIN_PASSWORD="admin"                                  _Mot de passe WordPress pour votre premier utilisateur_

## Utilisation

Il vous suffit de lancer la commande :

  ./lur_wp_install.sh nom_de_projet

Si nom_de_projet correspond à un dépôt présent dans gitolite Il sera puller automatiquement
Sinon il sera créé et votre thême, qui aura le même nom, sera initialisé.
