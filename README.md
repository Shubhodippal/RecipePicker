# Recipe Picker App

A versatile and user-friendly Flutter application for finding recipes based on selected courses, cuisine, diet, and cooking time. This app is designed to help users filter and discover recipes quickly and effortlessly. The app features an intuitive UI with customizable filtering options, including dynamically adjusted minimum and maximum cooking times based on user preferences.

## Features

- **Course Selection**: Choose from predefined courses (e.g., breakfast, lunch, dinner, snacks).
- **Cuisine Selection**: Filter recipes based on different cuisines, with specific options tailored to each course.
- **Diet Preferences**: Choose from a variety of diets, dynamically filtered to match the selected course and cuisine.
- **Cooking Time Slider**: Set a maximum cooking time (from 1 to 600 minutes) to match the available time.
- **Dynamic Filtering**: The app intelligently updates the minimum cooking time based on the chosen course, cuisine, and diet.
- **Responsive UI**: A clean and visually appealing interface designed to work smoothly on different screen sizes.
  
## Technologies Used

- **Flutter**: Used for building the cross-platform mobile application.
- **Dart**: The programming language for the Flutter application.
- **SQL**: Used for database management and querying.
- **PHP**: Used for server-side scripting and backend development.
- **RESTful API**: Used for app and server communication.
- **Python**: Used for data processing.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version X.X.X or later)
- Compatible IDE (e.g., [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio))
- Ensure you have enabled web support if running on the web.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Shubhodippal/RecipePicker.git
   cd recipe-picker-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Project Structure

- **lib/**: Contains all Dart code for the app.
  - **main.dart**: Entry point of the application.
- **assets/**: Contains assets used in the app.

### Usage

1. **Select Course**: Begin by selecting a course (e.g., Breakfast).
2. **Select Cuisine**: Choose a cuisine based on the course.
3. **Select Diet**: Pick a diet preference from the available options.
4. **Set Cooking Time**: Adjust the slider to filter recipes within the desired cooking time.

The app will filter and display only those recipes that match all selected criteria.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request to submit changes.

## License

This project is licensed under the MIT License.
