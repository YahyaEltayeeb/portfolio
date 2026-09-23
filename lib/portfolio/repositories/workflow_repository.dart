import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../models/workflow_step_model.dart';

class WorkflowRepository {
  const WorkflowRepository();

  List<WorkflowStepModel> getSteps() {
    return const [
      WorkflowStepModel(
        stepNumber: 1,
        title: AppStrings.step1Title,
        description: AppStrings.step1Desc,
        icon: Icons.lightbulb_outline_rounded,
      ),
      WorkflowStepModel(
        stepNumber: 2,
        title: AppStrings.step2Title,
        description: AppStrings.step2Desc,
        icon: Icons.account_tree_outlined,
      ),
      WorkflowStepModel(
        stepNumber: 3,
        title: AppStrings.step3Title,
        description: AppStrings.step3Desc,
        icon: Icons.code_rounded,
      ),
      WorkflowStepModel(
        stepNumber: 4,
        title: AppStrings.step4Title,
        description: AppStrings.step4Desc,
        icon: Icons.speed_rounded,
      ),
      WorkflowStepModel(
        stepNumber: 5,
        title: AppStrings.step5Title,
        description: AppStrings.step5Desc,
        icon: Icons.rocket_launch_outlined,
      ),
    ];
  }
}
