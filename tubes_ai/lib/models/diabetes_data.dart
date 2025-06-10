class DiabetesData {
  final int age;
  final double bmi;
  final double glucose;
  final double bp;
  final String label;

  DiabetesData({
    required this.age,
    required this.bmi,
    required this.glucose,
    required this.bp,
    required this.label,
  });

  factory DiabetesData.fromJson(Map<String, dynamic> json) {
    return DiabetesData(
      age: json['age'],
      bmi: json['bmi'].toDouble(),
      glucose: json['glucose'].toDouble(),
      bp: json['bp'].toDouble(),
      label: json['label'],
    );
  }
}
