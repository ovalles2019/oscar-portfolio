import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/project.dart';

List<Project> demoProjects = [];

Future<void> loadProjects() async {
  final jsonString = await rootBundle.loadString('lib/data/projects.json');
  final List<dynamic> data = json.decode(jsonString) as List<dynamic>;
  demoProjects = data
      .map((entry) => Project.fromJson(entry as Map<String, dynamic>))
      .toList();
}
