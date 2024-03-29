import 'package:medibuddy/models/medication.dart';
import 'package:medibuddy/models/medication_notification.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'medibuddy.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE medications(id TEXT PRIMARY KEY, name TEXT NOT NULL, type INTEGER NOT NULL)',
        );
        await database.execute(
          'CREATE TABLE notifications(id INTEGER PRIMARY KEY, time TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }

  void insertMedication(Medication medication) async {
    final Database db = await initializeDB();
    await db.insert('medications', medication.toMap());
  }

  Future<List<Medication>> fetchMedications() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('medications');
    return queryResult.map((e) => Medication.fromMap(e)).toList();
  }

  void deleteMedication(String id) async {
    final db = await initializeDB();
    db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void insertMedicationNotification(MedicationNotification notification) async {
    final Database db = await initializeDB();
    await db.insert('notifications', notification.toMap());
  }

  Future<List<MedicationNotification>> fetchMedicationNotifications() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('notifications');
    return queryResult.map((e) => MedicationNotification.fromMap(e)).toList();
  }

  void deleteMedicationNotification(String id) async {
    final db = await initializeDB();
    db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
