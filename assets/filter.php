<?php
$servername = "sdb-61.hosting.stackcp.net";
$username = "Recipe_Picker-353032377f84";
$password = "RECIPE_2024";
$dbname = "Recipe_Picker-353032377f84";
// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the filter values from the form
$course = isset($_POST['course']) ? $_POST['course'] : '';
$cuisine = isset($_POST['cuisine']) ? $_POST['cuisine'] : '';
$diet = isset($_POST['diet']) ? $_POST['diet'] : '';
$prep_time = isset($_POST['prep_time']) ? $_POST['prep_time'] : '';

// Base query
$query = "SELECT * FROM recipes WHERE 1=1";

// Add filters to the query if provided
if ($course) {
    $query .= " AND course = '$course'";
}

if ($cuisine) {
    $query .= " AND cuisine = '$cuisine'";
}

if ($diet) {
    $query .= " AND diet = '$diet'";
}

// Filter prep_time (less than the selected value)
if ($prep_time) {
    $query .= " AND prep_time < $prep_time";
}

// Execute the query
$result = $conn->query($query);

// Check if any recipes are found
if ($result->num_rows > 0) {
    echo "<h2>Filtered Recipes:</h2>";
    while ($row = $result->fetch_assoc()) {
        echo "<p><strong>Name:</strong> " . $row['name'] . "<br>";
        echo "<strong>Course:</strong> " . $row['course'] . "<br>";
        echo "<strong>Cuisine:</strong> " . $row['cuisine'] . "<br>";
        echo "<strong>Diet:</strong> " . $row['diet'] . "<br>";
        echo "<strong>Prep Time:</strong> " . $row['prep_time'] . " minutes</p><hr>";
    }
} else {
    echo "<p>No recipes found for the selected filters.</p>";
}

$conn->close();
?>
