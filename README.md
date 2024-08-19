# SpeechToDoList

SpeechToDoList is an iOS application that allows users to manage their to-do tasks with voice recognition capabilities. This app is designed to be simple and user-friendly, enabling users to add, update, and delete tasks efficiently. The app uses various modern frameworks and follows the MVC architectural pattern to ensure a robust and maintainable codebase.

## Features

- **Task Management:** Create, update, delete, and prioritize tasks.
- **Voice Recognition:** Add tasks using speech recognition (supports Russian locale).
- **Local Notifications:** Get notified about your tasks at the scheduled time.
- **Persisted Data:** All tasks are stored locally using Realm database.
- **Custom UI:** Clean and intuitive user interface with task prioritization and completion tracking.

## Technologies and Frameworks Used

- **Swift:** The programming language used for the entire application.
- **RealmSwift:** Used for local data storage, providing a fast and efficient database solution.
- **Speech Framework:** Enables voice recognition to allow users to add tasks via speech.
- **UserNotifications:** Manages local notifications to alert users about their tasks.
- **UIKit:** For building the user interface and managing interactions.

## Project Structure

- **DatabaseManager:** A singleton class responsible for managing tasks in the Realm database.
- **NotificationManager:** Manages the scheduling and sending of local notifications.
- **SpeechRecognizerManager:** Handles speech recognition functionalities, including starting and stopping recordings.
- **TaskObject:** Represents the task model in the Realm database with properties like `description`, `priority`, `date`, and `isComplete`.
- **Priority Enum:** Enum that defines the priority levels for tasks (low, normal, high, absolute).
- **View Controllers:** 
  - `TasksViewController`: Displays the list of tasks and handles user interactions such as adding, updating, and deleting tasks.
  - `SetupTaskViewController`: Manages the setup and configuration of individual tasks, including speech recognition input and setting priorities.
- **Custom UI Components:** 
  - `TaskTableViewCell`: Custom table view cell that displays task information and allows users to mark tasks as complete.
