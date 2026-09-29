
-- 1. Création des tables

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    avatar TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE conversations (
    id BIGSERIAL PRIMARY KEY,
    group_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    author_id BIGINT NOT NULL REFERENCES users(id),
    conversation_id BIGINT NOT NULL REFERENCES conversations(id),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_conversation (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    conversation_id BIGINT NOT NULL REFERENCES conversations(id),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, conversation_id)
);

CREATE TABLE user_message (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    message_id BIGINT NOT NULL REFERENCES messages(id),
    status VARCHAR(20) NOT NULL CHECK (status IN ('sent', 'delivered', 'read')),
    read_at TIMESTAMP,
    UNIQUE (user_id, message_id)
);

-- 2. Données d'exemple

-- Utilisateurs
INSERT INTO users (full_name, email, password) VALUES
('christian mwanya', 'christian.mwanya@gmail.com', 'motdepasse123'),
('junior kabala', 'junior.kabala@gmail.com', 'motdepasse321'),
('sarah imba', 'sarah.imba@gmail.com', 'motdepasse1235'),
('patrick dina', 'patrick.dina@gmail.com', 'motdepasse112255'),
('yorgen diasilua', 'yorgen.diasilua@gmail.com', 'motdepasse1255');

-- Conversations
INSERT INTO conversations (group_name) VALUES ('amis de l''ecole');
INSERT INTO conversations DEFAULT VALUES; -- conversation privée Christian <-> Junior
INSERT INTO conversations DEFAULT VALUES; -- conversation privée Sarah <-> Yorgen

-- Participants aux conversations
-- (1=Christian, 2=Junior, 3=Sarah, 4=Patrick, 5=Yorgen)
-- (conversations : 1=groupe, 2=privée C-J, 5=privée S-Y)
INSERT INTO user_conversation (user_id, conversation_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(1, 2),
(2, 2),
(3, 5),
(5, 5);

-- Messages
INSERT INTO messages (content, author_id, conversation_id) VALUES
('Salut tout le monde, comment ça va ?', 1, 1),
('Oui salut Christian, toi aussi tu vas bien ?', 2, 1),
('Coucou Christian, ça fait longtemps !', 2, 2),
('salut Junior, je suis trop pris ce dernier temps mais demain je vais passer chez toi a la maison', 1, 2),
('Salut sarah, tu es libre ce soir ?', 5, 5),
('salut bro, oui je suis libre !', 3, 5);

-- Statuts de lecture des messages (uniquement pour les destinataires, jamais l'auteur)
INSERT INTO user_message (user_id, message_id, status, read_at) VALUES
(2, 1, 'read', '2026-09-03 20:15:40'),
(3, 1, 'delivered', NULL),
(4, 1, 'sent', NULL),
(1, 2, 'read', '2026-09-03 20:22:40'),
(3, 2, 'sent', NULL),
(4, 2, 'delivered', NULL),
(1, 3, 'read', '2026-09-03 20:15:40'),
(2, 4, 'sent', NULL),
(3, 5, 'read', '2026-09-03 20:20:40'),
(5, 6, 'delivered', NULL);

-- 3. Requêtes 

-- Afficher tous les utilisateurs
SELECT * FROM users;

-- Afficher toutes les conversations
SELECT * FROM conversations;

-- Afficher les participants d'une conversation (ex: conversation 1)
SELECT users.full_name
FROM users
JOIN user_conversation ON users.id = user_conversation.user_id
WHERE user_conversation.conversation_id = 1;

-- Afficher les messages d'une conversation (ex: conversation 1)
SELECT * FROM messages WHERE conversation_id = 1;

-- Afficher les messages avec le nom de leur auteur
SELECT users.full_name, messages.content
FROM messages
JOIN users ON messages.author_id = users.id;

-- Afficher le dernier message d'une conversation (ex: conversation 1)
SELECT * FROM messages
WHERE conversation_id = 1
ORDER BY sent_at DESC
LIMIT 1;

-- Afficher les conversations d'un utilisateur (ex: Christian, id 1)
SELECT conversations.*
FROM conversations
JOIN user_conversation ON conversations.id = user_conversation.conversation_id
WHERE user_conversation.user_id = 1;

-- Compter le nombre de messages par conversation
SELECT conversation_id, COUNT(*) AS nombre_messages
FROM messages
GROUP BY conversation_id;

-- Rechercher un utilisateur par email
SELECT * FROM users WHERE email = 'christian.mwanya@gmail.com';

-- Rechercher les messages d'un utilisateur (en tant qu'auteur)
SELECT * FROM messages WHERE author_id = 1;

-- Soupression des conversations
DELETE FROM conversations WHERE id IN (3,4,6);

