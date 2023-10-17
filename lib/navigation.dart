import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medibuddy/medication_page.dart';
import 'package:medibuddy/medication_add_modal.dart';
import 'package:medibuddy/models/database_handler.dart';
import 'package:medibuddy/models/medication.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medibuddy/medication_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class NamesStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/medication_names.txt');
  }

  Future<List<String>> search(String query) async {
    if (query.length < 3) {
      return [query];
    }
    final names = await readNames();
    final List<String> filteredList = [query];

    for (var name in names) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(name);
      }
    }

    return filteredList;
  }

  Future<List<String>> readNames() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();
      // Change to '\n'
      final newMeds = contents.split("@");
      return newMeds.toList();
    } catch (e) {
      return [""];
    }
  }

  Future<File> updateNames() async {
    // Check if names were updated more than 1 week ago (add setting to change interval)
    // Fetch names from https://rxnav.nlm.nih.gov/REST/displaynames.json
    final response = await http.get(
      Uri.parse(
        'https://rxnav.nlm.nih.gov/REST/displaynames.json',
      ),
    );
    var webMeds = [];
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      webMeds = body["displayTermsList"]["term"];
    } else {
      print("Failed to get names");
    }
    // https://lhncbc.nlm.nih.gov/RxNav/APIs/api-RxNorm.getDisplayTerms.html
    var finalMeds = "";
    for (var med in webMeds) {
      // Change to '\n'
      if (!med.toString().contains("/")) {
        finalMeds = "$finalMeds$med@";
      }
    }

    final file = await _localFile;

    return file.writeAsString(finalMeds);
  }
}

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
    medsFuture = DatabaseHandler().fetchMedications();
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
      medsFuture = DatabaseHandler().fetchMedications();
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
          var handler = DatabaseHandler();
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
        const Placeholder()
      ][_currentPageIndex],
    );
  }
}
