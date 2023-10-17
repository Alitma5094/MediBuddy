import 'package:flutter/material.dart';
import 'package:medibuddy/models/medication.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage(
      {super.key, required this.medicationsFuture, required this.showMedModal});

  final Future<List<Medication>> medicationsFuture;
  final Function showMedModal;

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.medicationsFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<Medication>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? const Center(child: Text('Add a medication to get started.'))
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.medical_information),
                    ),
                    title: Text(snapshot.data![index].name),
                    subtitle: const Text('Supporting text'),
                    onTap: () => widget.showMedModal(snapshot.data![index]),
                    // trailing: Icon(Icons.favorite_rounded),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshot.data!.length,
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
