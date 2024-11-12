<?php
$servername = "sdb-61.hosting.stackcp.net";
$username = "Recipe_Picker-353032377f84";
$password = "RECIPE_2024";
$dbname = "Recipe_Picker-353032377f84";
$validPassword = "9163971594"; // Define the valid password here

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
$userPassword = isset($_POST['password']) ? $_POST['password'] : '';

// Check if the password matches
if ($userPassword !== $validPassword) {
    echo json_encode(['message' => 'Invalid password.']);
    $conn->close();
    exit;
}

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

// Initialize an array to hold the recipes
$recipes = [];

// Check if any recipes are found
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $recipes[] = [
            'name' => $row['name'],
            'course' => $row['course'],
            'cuisine' => $row['cuisine'],
            'diet' => $row['diet'],
            'prep_time' => $row['prep_time']
        ];
    }
} else {
    $recipes = ['message' => 'No recipes found for the selected filters.'];
}

// Return the result as JSON
header('Content-Type: application/json');
echo json_encode($recipes);

// Close the connection
$conn->close();
?>
