import 'package:flutter/material.dart';
import 'package:medibuddy/models/database_handler.dart';
import 'package:medibuddy/models/medication.dart';
import 'package:uuid/uuid.dart';
import 'package:medibuddy/navigation.dart';

// TODO: Add fields: Type, Strength (mg, mcg, g, mL, %)

class MedicationAddModal extends StatefulWidget {
  const MedicationAddModal({super.key});

  @override
  State<MedicationAddModal> createState() => _MedicationAddModalState();
}

class _MedicationAddModalState extends State<MedicationAddModal> {
  final _notesController = TextEditingController();

  void _onSavePressed(String name) {
    DatabaseHandler().insertMedication(
      Medication(
        id: const Uuid().v4(),
        name: name,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    _notesController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'New Medication',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Flexible(
            child: TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                label: Text('Medication name'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          FutureBuilder(
            future: NamesStorage().search(_notesController.text),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      title: Text(snapshot.data![index]),
                      onTap: () => _onSavePressed(snapshot.data![index]),
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.length,
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const SizedBox(
            height: 8,
          ),
          const Text("Scroll to see more results")
        ],
      ),
    );
  }
}
