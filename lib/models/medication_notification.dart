import 'package:flutter/material.dart';

class MedicationNotification {
  final int id;
  final TimeOfDay time;

  const MedicationNotification({required this.id, required this.time});

  MedicationNotification.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        time = TimeOfDay(
            hour: int.parse(res["time"].toString().split(":")[0]),
            minute: int.parse(res["time"].toString().split(":")[1]));

  Map<String, Object> toMap() {
    return {
      'id': id,
      'time': '${time.hour}:${time.minute}',
    };
  }
}
