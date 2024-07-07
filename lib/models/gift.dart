class Gift {
  String id;
  final String name;
  final String uri;
  String description;

  Gift({
    this.id = '',
    required this.name,
    required this.uri,
    this.description = '',
  });

  static Gift fromJson(Map<String, dynamic> json) =>
      Gift(name: json['name'], uri: json['image']);
}
