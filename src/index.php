<?php

$host = $_ENV["DATABASE_ADDRESS"];
$port = $_ENV["DATABASE_PORT"];
$server = $_ENV["SERVER_NAME"];
$database = $_ENV["DATABASE_NAME"];
$user = $_ENV["USER_NAME"];
$password = $_ENV["USER_PASSWORD"];


$dsn = "informix:host=$host;service=$port;database=$database;server=$server;protocol=onsoctcp;";
$user = "$user";
$pass = "$password";

$pdo = new PDO($dsn, $user, $pass);

$stmt = $pdo->query('SELECT FIRST 1 * FROM bas_cli');
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);


foreach ($rows as $iteration) {
    foreach ($iteration as $key => $value) {
        echo "$key => $value  <br>";
    }
}
