class ProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthdate;
  final String sex;
  final String company;
  final String CRN;
  final bool isVerified;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.sex,
    required this.company,
    required this.CRN,
    required this.isVerified,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthdate: json['birthdate']?.toString() ?? '',
      sex: json['sex'] ?? '',
      company: json['company'] ?? '',
      CRN: json['commercial_register_number'] ?? '',
      isVerified: json['is_verified'],
    );
  }
}
