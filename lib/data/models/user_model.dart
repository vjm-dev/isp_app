import 'package:equatable/equatable.dart';
import 'package:isp_app/domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String planName;
  final double monthlyPayment;
  final double dataUsage;
  final double dataLimit;
  final DateTime lastUpdated;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.planName,
    required this.monthlyPayment,
    required this.dataUsage,
    required this.dataLimit,
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
      dataUsage: json['dataUsage'].toDouble(),
      dataLimit: json['dataLimit'].toDouble(),
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
      'dataUsage': dataUsage,
      'dataLimit': dataLimit,
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
      dataLimit: dataLimit,
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
        dataLimit,
      ];
}