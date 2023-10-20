import 'package:flutter/material.dart';
import 'package:medibuddy/medication_add_modal.dart';
import 'package:medibuddy/models/medication.dart';

class MedicationDetail extends StatefulWidget {
  const MedicationDetail({super.key, required this.medication, this.onDelete});

  final Medication medication;
  final Function? onDelete;

  @override
  State<MedicationDetail> createState() => _MedicationDetailState();
}

class _MedicationDetailState extends State<MedicationDetail> {
  void _onDeletePressed() {
    Navigator.pop(context);
    if (widget.onDelete != null) {
      widget.onDelete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: double.infinity,
            child: CircleAvatar(
              radius: 64,
              child: Icon(
                Icons.medical_information,
                size: 64,
              ),
            ),
          ),
          // const SizedBox(
          //   height: 16,
          // ),
          Text(
            widget.medication.name,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            "Type: ${widget.medication.type.toString().split(".")[1].toCapitalized()}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () => _onDeletePressed(),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.error),
            ),
            icon: const Icon(Icons.delete),
            label: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
