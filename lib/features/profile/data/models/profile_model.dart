class ProfileModel {
  final String id;
  final String name;
  final String email;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
