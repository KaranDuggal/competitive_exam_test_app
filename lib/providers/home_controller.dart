import 'package:flutter/material.dart';
import '../models/quiz_models.dart';

class HomeController extends ChangeNotifier {
  final List<ExamModel> _categories = [
    ExamModel(id: '1', title: 'UPSC', icon: '🏛️'),
    ExamModel(id: '2', title: 'SSC', icon: '📝'),
    ExamModel(id: '3', title: 'Banking', icon: '🏦'),
    ExamModel(id: '4', title: 'Railways', icon: '🚂'),
    ExamModel(id: '5', title: 'State PSC', icon: '🗺️'),
    ExamModel(id: '6', title: 'Police', icon: '👮'),
  ];

  List<ExamModel> get categories => _categories;
}
