# Pain points pour le multi-user setup

## Définitions

Multi users = Users sans compte AWS, venant "les mains dans les poches", façon "sec jam"
Single user = User avec un compte AWS valide, façon "cloud goat"
Infrastructure = services déployés pour le jeu, très général, pas nécessairement instancié
Instancié = déployé à chaque jeu avec un deployment manager
Cellule = groupe de gens jouant ensemble sur le même conteneur
Conteneur = Copie de l'infrastructure à laquelle seule une cellule a accès, pour ne pas se marcher sur les pieds

## Déploiement

Déploimenet multi-users requiert une autorité centrale:
-Doit déployer le bon nombre d'infrastructures pour les usagers (1 si free-for-all, X pour Y cellules sinon, X <= Y)
-Pas de free tier (nombre potetiellement important d'infrastructure)

### Instanciation du déploiement

(Détails techniques dans "Développement")
-Possible d'instancier chaque cellule, limité par le nombre de régions/le problème du listing
-Possibilité de faire du "statique" façon flAWS. C'est totalement différent, pas de privesc sur une même ressource (i.e. forcé de changer de clés/instances, ce qui coupe quelques possibilités)
-Alternative: Possiblité de faire une sorte de "mix", i.e. du "semi-instancié". Problème: on garde les problèmes séparés des deux méthodes, et il y a une zone d'ombre lors du/des passages entre les deux modes: comment rabattre un utilisateur qui était sur une ressource immuable sur sa ressource "personnelle"?

## Jeu

### Problème de la modification

Ou "pourquoi il faut des conteneurs". En gros pour une privesc (par exemple), il n'est pas envisageable de laisser tout les utilisateurs sur la même infrastructure: en effet, le premier qui réalise l'escalation va simplifier la vie de tous les autres (qui disposeraient du même utilisateur dans ce cas hypothétique)
Faire du conteneur permet d'éviter le "first-come-first-serve". En cas de blocage, ça permet aussi, si possible, de reset seulement pour une cellule plutôt que pour tout le monde: comme on fait rarement des scripts pour les exploits sur aws (ils sont rarement répétables/à répéter), les utilisateurs perdraient une grosse quantité de leur boulot sur un reset.

### Problème du listing

Un des, si pas le problème majeur.
En somme, lister les ressources d'un service AWS liste TOUTES les ressources, en dépit du VPC par exemple pour EC2. A la limite, la région permet de compartimenter ça, mais c'est assez peu pratique à utiliser (16 or so conteneurs maximum).
Idem pour les S3 mais sans possibilité de compartimenter avec la région.
Le problème reste entier: Soit il faut "limiter" le déploiment, et ça aura encore des conséquences sur certains services (s3, autres?)
C'est surtout pénible pour l'end user
La CLI semble presque trop puissante pour ce genre d'utilisations, cela dit la console permet également de procéder à un listing complet des ressources du compte, ce qui ne change pas grand chose.

### Problème du démarrage (ou de l'acheminement)

"Faux-problème", mais quelle que soit la façon de déployer, il faudrait un moyen de faire suivre les clés "de départ" aux usagers. Sec Jam le fait à l'aide d'une GUI et d'un site web, peut-être peut-on lancer un service web sur le réseau local?
Ce problème reste, certes, totalement secondaire.

## Développement

### Généralités

Pas de grosses contre-indications: Afin de permettre des resets de certains conteneurs de manière indépendante, il faudra de toute façon plusieurs backends de terraform. L'instanciation sera donc assez lourde, mais cela revient juste à développer avec une cellule en tête, et itérer le script sur le nombre de cellules. Au pire, ça prend de la place, du réseau, du CPU, mais rien de terrible.
On garde quand-même en ligne de mire un déploiement "full-instancié" ce qui limite beaucoup certaines missions (i.e. rien qui ne puisse pas être déployé on-the-fly: pas de front-end complexe, pas de github dans lequel trouver des clésé, pas de dns, etc.)

### Spécifiques aux missions

M1:

Pas grand chose, mais mission très sommaire. 0 modifications, tout en local.


M2:

Sans contre-indications


M3:

Compliqué. La mission se base sur le fait de pouvoir monter un volume sur l'EC2 (ou d'en créer une autre, mais dans une setup multi-users, laisser les cellules créer des ressources peut être risqué).

M5:

Au vu de la nature assez CTF-like de celle-ci, je pense que c'est compliqué de l'adapter à un TP à plusieurs. Trop gros, les gens perdraient intérêt assez vite et/ou se marcheraient dans les pattes. Ca reste, cela dit, discutable. Egalement des privesc "destructives" (i.e. pas répétables).

## Suggestions

Deux solutions au problème du listing me viennent en tête, mais aucune n'est très élégante:
-Un conteneur par région. Moche pour S3, limité à environ 16, etc. 
-Créer un nombre de comptes AWS "quelconques" appartenant à Stack Labs, et utilisant sa carte. Il faudrait en faire au maximum une dizaine, à la main. Ensuite, ranger des clés admin de CLI pour ces comptes dans un fichier local ou une database, et appeller les opérations de chaque conteneur dans chaque compte. Cette solution **garantit** l'isolation mais a un assez gros overhead (créer tous les comptes, maintenance (par ex changement de carte), etc), et franchement, c'est pas beau...

Plutôt que de reprendre le sec-game actuel, et essayer de le "forcer" dans le moule choisi, je pense qu'il est préférable de "commencer à finir" avant de se lancer sur un autre projet. Ca permet aussi d'avoir deux programmes cohérents entre eux et qui n'ont qu'un modèle plutôt qu'une seule codebase assez mixte avec deux use cases diamétralement opposés.
Une partie des templates pourra être réutilisée avec presque pas d'édition, mais il faudra certainement réécrire les scripts de manière un peu plus robuste

Pour le reset, terraform a une fonction de rollback. Cela dit, mieux vaut l'encapsuler un peu (avec une commande du script de lancement, par exemple).

En fonction du mode de déploiement choisi, il est possible d'aborder des types de challenge un peu différents: par exemple un déploiement statique permet facilement de faire rentrer des services plus "permanents" dans le challenge, comme des look-up DNS, etc.

