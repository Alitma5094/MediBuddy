class Medication {
  final String id;
  final String name;

  const Medication({
    required this.name,
    required this.id,
  });

  Medication.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
