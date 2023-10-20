enum StrengthUnit {
  mg,
  mcg,
  g,
  mL,
  //Percent
}

enum MedicationType {
  capsule,
  tablet,
  injection,
  cream,
  device,
  drops,
  foam,
  gel,
  inhaler,
  injectant,
  liquid,
  lotion,
  patch,
  powder,
  spray,
  suppository,
}

class Medication {
  final String id;
  final String name;
  final MedicationType type;

  const Medication({
    required this.id,
    required this.name,
    required this.type,
  });

  Medication.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        type = MedicationType.values[res["type"]];

  Map<String, Object> toMap() {
    return {'id': id, 'name': name, "type": type.index};
  }
}
