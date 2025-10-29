# Module de gestion de matériels pour Paheko

Ce module permet de gérer les matériels de l'association: stock,
entrées, sorties, classés par catégorie.

Un matériel peut entrer dans l'association :
- temporairement (location, emprunt, ...)
- définitivement (achat, ...)

Dans les deux cas, il est possible de lui associer une écriture de la
compta ou un fichier.

Un matériel appartenant à l'association peut sortir :
- temporairement (prêt, ...) : il est possible de lui associer un lieu
  de stockage ainsi qu'un membre dépositaire du matériel ; il peut
  ensuite revenir dans l'association.
- définitivement (vente, ...) : il est possible de lui associer un
  membre bénéficiaire du matériel.

Un matériel présent temporairement dans l'association peut être
retourné à son propriétaire.

Un matériel dont il n'existe plus d'exemplaire en stock peut être archivé.

On peut lister l'ensemble des mouvements des matériels ou seulement
ceux d'un matériel donné.

Il est possible de créer des catégories de matériels, des types
d'entrées et sorties, des lieux de stockage.

## Droits d'accès
Le module est accessible uniquement pour les membres ayant au moins le
droit d'écriture en gestion des membres.
