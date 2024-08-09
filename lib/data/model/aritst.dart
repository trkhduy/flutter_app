class Artist {
  String id;
  String name;
  DateTime? birthDay; // Có thể null

  Artist(this.id, this.name, this.birthDay);

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      json['id'] as String,
      json['name'] as String,
      json['birthDay'] != null ? DateTime.parse(json['birthDay'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDay': birthDay?.toIso8601String(), // Chuyển đổi DateTime thành chuỗi ISO 8601, nếu không null
    };
  }
}
