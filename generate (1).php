<?php
require 'vendor/autoload.php'; // Make sure Faker is installed via Composer

use Faker\Factory;

// Configuration de la base de données
$host = 'localhost';
$dbname = 'movies_test';
$username = 'root';
$password = '';

// Connexion à la base de données MySQL avec MySQLi
$conn = new mysqli($host, $username, $password, $dbname);

// Vérification de la connexion
if ($conn->connect_error) {
    die("Connexion échouée : " . $conn->connect_error);
}

// Nombre de données factices à générer
$numberOfUsers = 10; // Modifier selon le besoin
$numberOfMovies = 5; 
$numberOfWatchHistory = 15; 
$numberOfReviews = 20;

// Initialisation de Faker
$faker = Factory::create();

// Insertion des données factices dans Subscription
$subscriptions = [
    ['Basic', 5.99],
    ['Premium', 11.99]
];

foreach ($subscriptions as $index => $subscription) {
    $stmt = $conn->prepare("INSERT IGNORE INTO subscription (subscriptionType, monthlyFee) VALUES (?, ?)");
    $stmt->bind_param('sd', $subscription[0], $subscription[1]);
    $stmt->execute();
    $stmt->close();
}

// Générer des utilisateurs factices
for ($i = 1; $i <= $numberOfUsers; $i++) {
    $firstName = $faker->firstName;
    $lastName = $faker->lastName;
    $email = $faker->unique()->safeEmail;
    $registrationDate = $faker->date;
    $subscriptionId = $faker->numberBetween(1, count($subscriptions));

    $stmt = $conn->prepare("INSERT INTO users (firstName, lastName, email,registrationDate, subscriptionId) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('ssssi', $firstName, $lastName, $email, $registrationDate, $subscriptionId);
    $stmt->execute();
    $stmt->close();
}

// Générer des films factices
for ($i = 1; $i <= $numberOfMovies; $i++) {
    $title = $faker->sentence(3);
    $genre = $faker->randomElement(['Comedy', 'Horror', 'Romance', 'Science Fiction', 'Documentary']);
    $releaseYear = $faker->year;
    $duration = $faker->numberBetween(80, 180); // Durée entre 80 et 180 minutes
    $rating = $faker->randomElement(['PG', 'PG-13', 'R']);

    $stmt = $conn->prepare("INSERT INTO movie (title, genre, releaseYear, duration, rating) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('sssis', $title, $genre, $releaseYear, $duration, $rating);
    $stmt->execute();
    $stmt->close();
}

// Générer des historiques de visionnage factices
for ($i = 1; $i <= $numberOfWatchHistory; $i++) {
    $userId = $faker->numberBetween(1, $numberOfUsers);
    $movieId = $faker->numberBetween(1, $numberOfMovies);
    $watchdate = $faker->date;
    $completionpercentage = $faker->numberBetween(0, 100);

    $stmt = $conn->prepare("INSERT INTO watchhistory (userId, movieId, watchdate, completionpercentage) VALUES (?, ?, ?, ?)");
    $stmt->bind_param('iisi', $userId, $movieId, $watchdate, $completionpercentage);
    $stmt->execute();
    $stmt->close();
}

// Générer des critiques factices
for ($i = 1; $i <= $numberOfReviews; $i++) {
    $userId = $faker->numberBetween(1, $numberOfUsers);
    $movieId = $faker->numberBetween(1, $numberOfMovies);
    $rating = $faker->numberBetween(1, 5);
    $reviewText = $faker->optional()->sentence(10);
    $reviewDate = $faker->date;

    $stmt = $conn->prepare("INSERT INTO review (userId, movieId, rating, reviewText, reviewDate) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('iisis',$userId, $movieId, $rating, $reviewText, $reviewDate);
    $stmt->execute();
    $stmt->close();
}

echo "Fake data inserted successfully!";

// Fermer la connexion
$conn->close();
?>
