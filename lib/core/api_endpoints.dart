abstract class ApiEndpoints {
  static const port = '8080';
  static const baseUrl = 'http://localhost:$port/v1'; // e.g. 'https://api.isp-test.com/v1';
  
  static String login() => '$baseUrl/auth/login';
  static String userData(String userId) => '$baseUrl/users/$userId/data';
  static String updateUsage(String userId) => '$baseUrl/users/$userId/usage';
  static String plans() => '$baseUrl/plans';
}