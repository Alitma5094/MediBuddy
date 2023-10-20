import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

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
