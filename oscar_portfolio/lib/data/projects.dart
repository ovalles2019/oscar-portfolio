import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/project.dart';

List<Project> demoProjects = [];

Future<void> loadProjects() async {
  final jsonString = await rootBundle.loadString('lib/data/projects.json');
  final List<dynamic> data = json.decode(jsonString);
  demoProjects = data.map((e) => Project.fromJson(e)).toList();
}
