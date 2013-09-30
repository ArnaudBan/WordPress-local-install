LUR WordPress Installer
=======================

Installer ou créer en une ligne votre projet WordPress en local

Pré-requis
---------

Pour fonctionner ce script a besoin de wp-cli. Installer le en suivant les instructions qui vous trouverez ici :
http://wp-cli.org/

config.conf
-----------

Créer votre fichier de configuration en duplicant le fichier config-sample.conf et le nomant config.conf
Vous devez y paramétrer :

  * WORK_DIR="/Users/arnaud/Workspace/" - Le chemin complet vers votre dossier local où sont installer vos fichiers
  * DBUSER="root"                       - Votre nom d'utilisateur pour MySQL
  * DBPASS="root"                       - Votre mot de passe MySQL
  * ADMIN_EMAIL="abanvillet@eluere.com" - L'email Admin que vous souhaitez pour vos install WordPress
  * ADMIN_PASSWORD="admin"              - Mot de passe WordPress de votre install local. Le nom d'utilisatateur sera "admin"

Utilisation
-----------

Il vous suffit de lancer la commande :

  ./lur_wp_install.sh nom_de_projet

Si nom_de_projet correspond a un dépôt présent dans gitolite Il sera puller automatiquement
Sinon il sera créer et votre thême, qui aura le même nom, sera initialisé. (C'est la partie qui reste a faire)