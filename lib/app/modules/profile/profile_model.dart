class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String birthdate;
  final String sex;
  final String company;
  final String CRN;
  final bool isVerified;

  ProfileModel({
    required this.name,
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
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthdate: json['birthdate'] ?? '',
      sex: json['sex'] ?? '',
      company: json['company'] ?? '',
      CRN: json['commercial_register_number'] ?? '',
      isVerified: json['is_verified'],
    );
  }
}
