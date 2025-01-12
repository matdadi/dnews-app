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

    queryParams['first_name'] = firstName;
    if (lastName != null) queryParams['last_name'] = lastName!;
    queryParams['username'] = username;
    queryParams['email'] = email;
    queryParams['password'] = password;

    return queryParams;
  }
}
