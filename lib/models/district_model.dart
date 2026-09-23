import 'package:flutter/material.dart';
import 'project_model.dart';

class DistrictModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<String> highlights;
  final List<ProjectModel> projects;
  final Offset mapPosition; // Relative position (0-1 range)

  const DistrictModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.highlights,
    required this.projects,
    required this.mapPosition,
  });

  int get projectCount => projects.length;
}
