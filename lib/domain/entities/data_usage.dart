class DataUsage {
  final DateTime startDate;
  final DateTime endDate;
  final double used;
  final double limit;
  final List<DataConsumption> dailyUsage;

  double get remaining => limit - used;
  double get percentage => used / limit;

  const DataUsage({
    required this.startDate,
    required this.endDate,
    required this.used,
    required this.limit,
    required this.dailyUsage,
  });

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'used': used,
      'limit': limit,
      'daily_usage': dailyUsage.map((e) => e.toJson()).toList(),
    };
  }
}

class DataConsumption {
  final DateTime date;
  final double download;
  final double upload;

  const DataConsumption({
    required this.date,
    required this.download,
    required this.upload,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'download': download,
      'upload': upload,
    };
  }
}