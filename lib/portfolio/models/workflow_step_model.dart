import 'package:flutter/material.dart';

class WorkflowStepModel {
  final int stepNumber;
  final String title;
  final String description;
  final IconData icon;

  const WorkflowStepModel({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
  });
}
