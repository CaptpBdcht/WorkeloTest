# Install & Run tests

```sh
bundle install

rake
```

## Test #1

Run the tests, see comments in availabilities.rb & availabilities_spec.rb

## Test #2

L'entité Task à deux attributs :
- done (boolean)
- due_date (date)

> "(A) Les notifications sont visibles partout dans l'application (à droite sur la navbar) : l'onboardee peut les consulter."

Au chargement de l'app, par exemple suite à la connexion, charger les tâches avec le critère suivant :
- La tâche n'est pas effectuée (done = false)
- La due_date est avant ce soir minuit
Stocker uniquement les tâches en retard nous obligerait à vérifier au cours de la journée si certaines tâches ne sont pas devenues en retard.
Récupérer les tâches qui expireront aujourd'hui permet d'éviter une nouvelle requête à chaque arrivée sur la homepage.

> "Il est important que cette fonctionnalité de notification ralentisse le moins possible le fonctionnement de l'app - le chargement des pages en particulier."

Utiliser un système de cache dans le front permettra de récupérer les tâches en retard dans notre liste locale à chaque fois que ce sera nécessaire.
Nous avons notamment toutes les tâches qui pourraient devenir en retard au cours de la journée grâce à la requête donnée précédemment.

> Que faire si l'utilisateur ne se déconnecte pas à minuit ?

Il suffit d'ajouter une logique de refresh dans la récupération des tâches en cache -
- Si la date de création du cache est différente de la date courante, réeffectuer la requête de chargement des tâches en retard.

> "(B) Les notifications sont envoyées une fois par semaine, le mardi, à l'onboardee par email."

Il s'agit de scheduler une tâche rake dans le back qui enverra ces notifications tous les mardis.
Afin d'éviter de charger les serveurs lorsque les utilisateurs sont le + sur l'app, il serait pertinent de choisir un horaire où le traffic est minimal.
