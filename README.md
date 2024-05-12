# Guide d'utilisation de l'application Life Manager


## Lancement de l'API

Pour lancer l'API de Life Manager :

1. Ouvrez un terminal.
2. Accédez au dossier `Life_Manager`.
3. Exécutez la commande suivante :
    ```bash
    go run main.go
    ```
   Cette commande lancera l'API de Life Manager.

---

## Lancement de l'application

Après avoir démarré l'API, vous pouvez lancer l'application Life Manager en suivant ces étapes :

1. Ouvrez un nouveau terminal.
2. Accédez au dossier `lifemanagerapp`.
3. Accédez au dossier `lib`.
4. Exécutez la commande suivante :
    ```bash
    flutter run
    ```
   Cette commande lancera l'application Life Manager.

5. Lorsque vous êtes invité à choisir une plateforme, appuyez sur `1` pour sélectionner Windows.

6. L'application se lancera et sera accessible une fois le processus de compilation terminé.

---

## Résolution des problèmes de lancement

Si vous rencontrez des erreurs lors du lancement de l'application, suivez ces étapes pour les résoudre :

1. Ouvrez un terminal.
2. Accédez au dossier `lifemanagerapp/lib`.
3. Exécutez la commande suivante pour nettoyer les fichiers temporaires :
    ```bash
    flutter clean
    ```
4. Réexécutez la commande `flutter run` pour lancer à nouveau l'application.

---

## Bug potentiel de fonctionnalité dans l'application

Il est possible que vous rencontriez des bugs dans certaines fonctionnalités de nos pages :

1. Dans la page securité, quand on veut générer un mot de passe aléatoire en appuyant sur le bouton vous pourrez observer qu'il n'affiche rien, il faut quitter la popup et revenir et la vous trouverez le mot de passe générer (surement un problème de rafraichissement que nous n'avons pas eu le temps de resoudre)

---

2. Dans la page dépense, il y a deux bugs, le premier correspond au filtrage par jour, année, mois. Quand on filtre avec donc le jour le mois ou l'année ça le filtre bien en revanche, quand il y a rien a un jour a un mois ou a une année ça n'affiche pas une liste vide, les éléments restent dans la liste.  Le deuxième bug est quand on ajoute une dépense, quand on ajoute une dépense il faut choisir la catégorie de sa dépense et la sous-catégorie, quand on choisit la categorie tout va bien mais une fois la categorie choisie il faut RE choisir la categorie pour que ça affiche les sous-catégories, encore une fois un bug de rafraichissement encore.



