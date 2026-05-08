import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_models.dart';

class LocalJsonDataSource {
  Future<Map<String, dynamic>> _loadJsonData() async {
    final String response = await rootBundle.loadString('assets/data/quiz_data.json');
    return json.decode(response);
  }

  Future<List<ExamModel>> getExams() async {
    final data = await _loadJsonData();
    final List exams = data['exams'];
    return exams.map((e) => ExamModel.fromJson(e)).toList();
  }

  Future<List<SubjectModel>> getSubjects(String examId) async {
    final data = await _loadJsonData();
    final List subjects = data['subjects'];
    return subjects
        .where((s) => s['examId'] == examId)
        .map((s) => SubjectModel.fromJson(s))
        .toList();
  }

  Future<List<ChapterModel>> getChapters(String subjectId) async {
    final data = await _loadJsonData();
    final List chapters = data['chapters'];
    return chapters
        .where((c) => c['subjectId'] == subjectId)
        .map((c) => ChapterModel.fromJson(c))
        .toList();
  }

  Future<List<QuestionModel>> getQuestions(String chapterId) async {
    final data = await _loadJsonData();
    final List questions = data['questions'];
    return questions
        .where((q) => q['chapterId'] == chapterId)
        .map((q) => QuestionModel.fromJson(q))
        .toList();
  }
}
