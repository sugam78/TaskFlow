class ApiConstants{

  static const baseUrl = 'http://10.0.2.2:3000/api';
  static final String webSocket = 'http://10.0.2.2:3000';

  static final String signUp = '$baseUrl/signup';
  static final String login = '$baseUrl/login';
  static final String getMyGroups = '$baseUrl/getMyGroups';
  static final String getGroup = '$baseUrl/getGroup';
  static final String createGroup = '$baseUrl/createGroup';
  static final String sendMessage = '$baseUrl/sendMessage';
  static final String fetchMessage = '$baseUrl/groupMessages';
  static final String createTask = '$baseUrl/createTask';
  static final String updateTask = '$baseUrl/updateTask';
  static final String myTasks = '$baseUrl/myTasks';
  static final String uploadImage = '$baseUrl/file/upload';
  static final String myProfile = '$baseUrl/myProfile';
  static final String changePassword = '$baseUrl/changePassword';

}