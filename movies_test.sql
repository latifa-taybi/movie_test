-- nom : LATIFA TAYBI
-- email : taybilatifa46@gmail.com

-- create database
CREATE DATABASE movies_test;
USE movies_test;

-- create table subscription
CREATE TABLE subscription(
    subscriptionId int AUTO_INCREMENT PRIMARY KEY, 
    subscriptionType varchar(50) NOT NULL, 
    CHECK(subscriptionType = 'basic' OR subscriptionType = 'premium'), 
    monthlyFee decimal(10,2) NOT NULL
);

-- create table users
CREATE TABLE users(
    userId int AUTO_INCREMENT PRIMARY KEY,
    firstName varchar(100) NOT NULL,
    lastName varchar(100) NOT NULL,
    email varchar(100) UNIQUE,
    registrationDate date NOT NULL,
    subscriptionId int,
    FOREIGN KEY (subscriptionId) REFERENCES subscription(subscriptionId)
);

-- create table movie
CREATE TABLE movie( 
    movieId int AUTO_INCREMENT PRIMARY KEY, 
    title varchar(255) NOT NULL UNIQUE, 
    genre varchar(255) NOT NULL, 
    releaseYear int NOT NULL, 
    duration int NOT NULL, 
    rating varchar(10) NOT NULL 
);

-- create table watchhistory
CREATE TABLE watchhistory( 
    watchhistoryId int AUTO_INCREMENT PRIMARY KEY, 
    watchdate date NOT NULL, 
    completionpercentage int DEFAULT 0, 
    userId int, 
    movieId int, 
    FOREIGN KEY (userId) REFERENCES users(userId), 
    FOREIGN KEY (movieId) REFERENCES movie(movieId)
);

-- create table review
CREATE TABLE review(
    reviewId int AUTO_INCREMENT PRIMARY KEY,
    rating int NOT NULL,
    reviewText text,
    reviewDate date NOT NULL,
    userId int, 
    movieId int, 
    FOREIGN KEY (userId) REFERENCES users(userId), 
    FOREIGN KEY (movieId) REFERENCES movie(movieId)
);
-- Insérer un film : Ajouter un nouveau film intitulé Data Science Adventures dans le genre "Documentary".
INSERT INTO movie(title, genre, releaseYear, duration, rating) 
VALUES ('hello','documentary','2002','30','kk');

-- Rechercher des films : Lister tous les films du genre "Comedy" sortis après 2020
SELECT * FROM movie WHERE genre = 'Comedy' AND releaseYear > 2020;

-- Mise à jour des abonnements : Passer tous les utilisateurs de "Basic" à "Premium"..
UPDATE users 
SET subscriptionId = (SELECT subscriptionId FROM subscription WHERE subscriptionType = 'premium' LIMIT 1) 
WHERE subscriptionId = (SELECT subscriptionId FROM subscription WHERE subscriptionType = 'basic' LIMIT 1);

-- Afficher les abonnements : Joindre les utilisateurs à leurs types d'abonnements.
SELECT U.firstName, U.lastName, S.subscriptionType
FROM users U
JOIN subscription S ON S.subscriptionId = U.subscriptionId;

-- Filtrer les visionnages : Trouver tous les utilisateurs ayant terminé de regarder un film.SELECT U.firstName, U.lastName, M.title, W.watchdate
SELECT U.firstName, U.lastName, M.title, W.completionpercentage
FROM watchhistory W
JOIN users U ON W.userId = U.userId
JOIN movie M ON W.movieId= M.movieId
WHERE W.completionpercentage = 100;

-- Trier et limiter : Afficher les 5 films les plus longs, triés par durée.
SELECT M.title, M.duration
FROM movie M
ORDER BY M.duration DESC
LIMIT 5;

-- Agrégation : Calculer le pourcentage moyen de complétion pour chaque film.
SELECT AVG(W.completionpercentage), M.title 
FROM watchhistory W 
RIGHT JOIN movie M ON W.movieId= M.movieId 
GROUP BY M.title;

-- Group By : Grouper les utilisateurs par type d’abonnement et compter le nombre total d’utilisateurs par groupe.SELECT S.subscriptionType, COUNT(userId)
SELECT S.subscriptionType, COUNT(U.userId)
FROM users U
JOIN subscription S ON S.subscriptionId = U.subscriptionId
GROUP BY S.subscriptionType;

-- Sous-requête (Bonus): Trouver les films ayant une note moyenne supérieure à 4.
SELECT M.title,(
    SELECT AVG(R.rating) 
    FROM review R 
    WHERE R.movieId = M.movieId) AS moyenne
FROM movie M
GROUP BY  M.title
HAVING moyenne > 4;
