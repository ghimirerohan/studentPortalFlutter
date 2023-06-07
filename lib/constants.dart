class ApiConstants {
  static int prodNdevMode = 2;
  static String protocol = 'https' ;

// static String baseUrl = '103.235.199.42:9130';
//   static String baseUrl =  'sis.nou.edu.np';
  static String baseUrl =  'ltu.phnx.com.np';
  static String port =prodNdevMode == 1 ? ':82' : '';
  static String auth_post_endponit = '/api/v1/auth/tokens';
  static String auth_put_endponit = '/api/v1/auth/tokens?=';
}