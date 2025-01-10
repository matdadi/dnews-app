class RegisterParam {
  String firstName;
  String? lastName;
  String username;
  String email;
  String password;

  RegisterParam({
    required this.firstName,
    this.lastName,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> queryParams = {};

    queryParams['first_name-500'] = firstName;
    if (lastName != null) queryParams['last_name-500'] = lastName!;
    queryParams['user_login-500'] = username;
    queryParams['user_email-500'] = email;
    queryParams['user_password-500'] = password;
    queryParams['confirm_user_password-500'] = password;
    queryParams['form_id'] = 500;
    queryParams['_wp_http_referer'] = '/register/';

    return queryParams;
  }
}
