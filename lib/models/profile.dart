class Profile {
  String id;
  final String user;
  final String name;
  final String email;
  String description;

  Profile({
    this.id = '',
    this.user = 'current',
    required this.name,
    required this.email,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'name': name,
        'email': email,
        'description': description
      };

  static Profile fromJson(Map<String, dynamic> json) =>
      Profile(id: json['id'], name: json['name'], email: json['email']);
}
