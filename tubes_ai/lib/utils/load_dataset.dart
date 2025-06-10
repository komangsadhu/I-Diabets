import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/diabetes_data.dart';

Future<List<DiabetesData>> loadDiabetesDataset() async {
  final String data = await rootBundle.loadString(
    'assets/diabetes_dataset_1000.json',
  );
  final List<dynamic> jsonResult = json.decode(data);
  return jsonResult.map((item) => DiabetesData.fromJson(item)).toList();
}
