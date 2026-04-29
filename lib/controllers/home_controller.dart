import 'package:flutter/material.dart';
import '../models/quiz_category.dart';

class HomeController extends ChangeNotifier {
  final List<QuizCategory> _categories = [
    QuizCategory(id: '1', title: 'UPSC', icon: '🏛️'),
    QuizCategory(id: '2', title: 'SSC', icon: '📝'),
    QuizCategory(id: '3', title: 'Banking', icon: '🏦'),
    QuizCategory(id: '4', title: 'Railways', icon: '🚂'),
    QuizCategory(id: '5', title: 'State PSC', icon: '🗺️'),
    QuizCategory(id: '6', title: 'Police', icon: '👮'),
  ];

  List<QuizCategory> get categories => _categories;
}
