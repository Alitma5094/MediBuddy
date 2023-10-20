import 'package:flutter/material.dart';
import 'package:medibuddy/models/database_handler.dart';
import 'package:medibuddy/models/medication.dart';
import 'package:uuid/uuid.dart';
import 'package:medibuddy/name_storage.dart';

// TODO: Add fields: Type, Strength (mg, mcg, g, mL)
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class MedicationAddModal extends StatefulWidget {
  const MedicationAddModal({super.key});

  @override
  State<MedicationAddModal> createState() => _MedicationAddModalState();
}

class _MedicationAddModalState extends State<MedicationAddModal> {
  var screenNum = 0;
  var selectedName = "";
  var selectedType;

  void _onSavePressed() {
    DatabaseHandler().insertMedication(
      Medication(
        id: const Uuid().v4(),
        name: selectedName,
        type: selectedType,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var toRender = [
      Column(
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
              onChanged: (newValue) {
                setState(() {
                  selectedName = newValue;
                });
              },
              decoration: const InputDecoration(
                label: Text('Medication name'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          FutureBuilder(
            future: NamesStorage().search(selectedName),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      title: Text(snapshot.data![index]),
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(
                          () {
                            selectedName = snapshot.data![index];
                            screenNum++;
                          },
                        );
                      },
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
      Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Medication Type',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  MedicationType.values[index].name
                      .split(".")[0]
                      .toCapitalized(),
                ),
                onTap: () {
                  setState(
                    () {
                      selectedType = MedicationType.values[index];
                    },
                  );
                  _onSavePressed();
                },
                // onTap: widget.onScreenAdvance(MedicationType.values[index]),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: MedicationType.values.length,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => setState(
                  () {
                    screenNum--;
                  },
                ),
                child: const Text("Back"),
              ),
              // FilledButton(
              //   onPressed: _onSavePressed,
              //   child: const Text("Save"),
              // )
            ],
          ),
        ],
      )
    ][screenNum];

    return Padding(padding: const EdgeInsets.all(24), child: toRender);
  }
}
