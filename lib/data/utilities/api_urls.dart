class ApiUrls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static const String registration = '$_baseUrl/registration';
  static const String logIn = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String newTask = '$_baseUrl/listTaskByStatus/New';
  static const String completedTask = '$_baseUrl/listTaskByStatus/Completed';
  static const String canceledTask = '$_baseUrl/listTaskByStatus/Canceled';
  static const String inProgressTask = '$_baseUrl/listTaskByStatus/InProgress';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static const String updateProfile = '$_baseUrl/profileUpdate';
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatus(String taskId, String status) => '$_baseUrl/updateTaskStatus/$taskId/$status';
  static String recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyOTP(String email, String pin) => '$_baseUrl/RecoverVerifyOTP/$email/$pin';
  static const String resetPassword = '$_baseUrl/RecoverResetPass';
}