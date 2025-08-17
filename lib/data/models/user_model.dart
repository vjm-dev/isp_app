import 'package:equatable/equatable.dart';
import 'package:isp_app/domain/entities/data_usage.dart';
import 'package:isp_app/domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String planName;
  final double monthlyPayment;
  final DataUsage dataUsage;
  final DateTime lastUpdated;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.planName,
    required this.monthlyPayment,
    required this.dataUsage,
    required this.lastUpdated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      planName: json['planName'],
      monthlyPayment: json['monthlyPayment'].toDouble(),
      dataUsage: DataUsage(
        startDate: DateTime.parse(json['data_usage']['start_date']),
        endDate: DateTime.parse(json['data_usage']['end_date']),
        used: json['data_usage']['used'].toDouble(),
        limit: json['data_usage']['limit'].toDouble(),
        dailyUsage: (json['data_usage']['daily_usage'] as List).map((e) => 
          DataConsumption(
            date: DateTime.parse(e['date']),
            download: e['download'].toDouble(),
            upload: e['upload'].toDouble(),
          )).toList(),
      ),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'planName': planName,
      'monthlyPayment': monthlyPayment,
      'data_usage': {
        'start_date': dataUsage.startDate.toIso8601String(),
        'end_date': dataUsage.endDate.toIso8601String(),
        'used': dataUsage.used,
        'limit': dataUsage.limit,
        'daily_usage': dataUsage.dailyUsage.map((e) => {
          'date': e.date.toIso8601String(),
          'download': e.download,
          'upload': e.upload,
        }).toList(),
      },
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      planName: planName,
      monthlyPayment: monthlyPayment,
      dataUsage: dataUsage,
      lastUpdated: lastUpdated,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        email,
        phone,
        planName,
        monthlyPayment,
        dataUsage,
        lastUpdated,
      ];
}