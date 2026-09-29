# Kadea Chat — Base de données

## Présentation

Kadea Chat est une plateforme de messagerie destinée aux apprenants de Kadea Academy. Ce dépôt contient la conception et la mise en place de la base de données relationnelle PostgreSQL de l'application, réalisée dans le cadre du capstone de fin de module 3 (Base de données) chez Kadea Academy.

La base de données permet de gérer les utilisateurs, les conversations (privées ou de groupe), les messages échangés, ainsi que le statut de lecture de chaque message (envoyé, délivré, lu) pour chaque destinataire.

## Technologies

- PostgreSQL
- pgAdmin 4
- Draw.io (MCD / MLD / Dictionnaire de données)
- SQL

## Modélisation

La base de données repose sur 5 tables :

- **`users`** : les utilisateurs de l'application (nom, email, mot de passe, avatar).
- **`conversations`** : les conversations, privées (2 personnes) ou de groupe (nom facultatif).
- **`messages`** : les messages envoyés, rattachés à un auteur et à une conversation.
- **`user_conversation`** : table de jonction représentant la participation d'un utilisateur à une conversation (relation N:N).
- **`user_message`** : table de jonction représentant le statut de lecture d'un message pour chaque destinataire (relation N:N), avec les valeurs `sent`, `delivered`, `read`.

Un message est envoyé par un seul utilisateur et appartient à une seule conversation. Une conversation peut avoir plusieurs participants, et un utilisateur peut participer à plusieurs conversations.

## Installation

1. Avoir PostgreSQL installé et un accès à pgAdmin 4.
2. Ouvrir pgAdmin, se connecter au serveur PostgreSQL.
3. Ouvrir une fenêtre **Query Tool**.
4. Ouvrir (ou coller) le fichier `database.sql` de ce dépôt.
5. Exécuter le script dans l'ordre : création de la base, création des tables, insertion des données de test.
6. Les requêtes de test, en fin de fichier, peuvent être exécutées séparément pour vérifier le bon fonctionnement de la base.

## Draw.io

Lien vers Draw.io (lecture seule) : [https://app.diagrams.net/#G1YDmv82TUipytQsis9rRtpzziPXwvMUhf#%7B%22pageId%22%3A%22DIWPatY_C4BO_iWA-JCJ%22%7D]

## Structure du projet

```
├── database.sql        # Script complet : création, contraintes, données, requêtes de test
├── README.md            # Ce fichier
├── screenshots/          # Captures d'écran pgAdmin (structure, tables, requêtes)
└── kadea-chat.drawio     # Fichier Draw.io (dictionnaire de données, MCD, MLD)
```