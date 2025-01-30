class DisbursementRecord {
  final String department;
  final DateTime dateTime; // 불출 시간
  final int sample1Count; // sample1 개수
  final int sample2Count; // sample2 개수
  final String otherItem; // 사용자가 입력한 기타 항목

  DisbursementRecord({
    required this.department,
    required this.dateTime,
    required this.sample1Count,
    required this.sample2Count,
    required this.otherItem, // 기타 항목
  });

  Map<String, dynamic> toJson() => {
    'department': department,
    'dateTime': dateTime.toIso8601String(),
    'sample1Count': sample1Count,
    'sample2Count': sample2Count,
    'otherItem': otherItem,
  };

  // JSON 로드
  factory DisbursementRecord.fromJson(Map<String, dynamic> json) => DisbursementRecord(
    department: json['department'] ?? 'Unknown',  // null일 경우 'Unknown' 사용
    dateTime: DateTime.parse(json['dateTime'] ?? '1970-01-01T00:00:00Z'),  // null일 경우 기본 날짜 사용
    sample1Count: json['sample1Count'] ?? 0,  // null일 경우 0 사용
    sample2Count: json['sample2Count'] ?? 0,  // null일 경우 0 사용
    otherItem: json['otherItem'] ?? 'No other item',  // null일 경우 기본 값 사용
  );

  @override
  String toString() {
    return "$department, Time: ${dateTime.toString()}, Sample1: $sample1Count, Sample2: $sample2Count, Other Items: $otherItem";
  }
}