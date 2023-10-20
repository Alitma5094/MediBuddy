import 'package:flutter/material.dart';
import 'package:medibuddy/medication_page.dart';
import 'package:medibuddy/medication_add_modal.dart';
import 'package:medibuddy/models/database_handler.dart';
import 'package:medibuddy/models/medication.dart';

import 'package:medibuddy/medication_detail.dart';
import 'package:medibuddy/settings_page.dart';

import 'package:medibuddy/name_storage.dart';

final handler = DatabaseHandler();

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;
  late Future<List<Medication>> medsFuture;

  @override
  void initState() {
    medsFuture = handler.fetchMedications();
    NamesStorage().updateNames();
    super.initState();
  }

  void showNewMedModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      isDismissible: false,
      builder: (context) => const MedicationAddModal(),
    );

    setState(() {
      medsFuture = handler.fetchMedications();
    });
  }

  void showMedModal(Medication medication) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      builder: (context) => MedicationDetail(
        medication: medication,
        onDelete: () {
          handler.deleteMedication(medication.id);
          setState(() {
            medsFuture = handler.fetchMedications();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediBuddy')),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.medication,
            ),
            label: 'Medications',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Options',
          ),
        ],
      ),
      floatingActionButton: _currentPageIndex == 0
          ? FloatingActionButton(
              onPressed: () => showNewMedModal(),
              child: const Icon(Icons.add),
            )
          : null,
      body: [
        MedicationPage(
          medicationsFuture: medsFuture,
          showMedModal: (med) => showMedModal(med),
        ),
        const SettingsPage()
      ][_currentPageIndex],
    );
  }
}
