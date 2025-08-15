import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String planName;
  final double monthlyPayment;
  final double dataUsage;
  final double dataLimit;
  bool get isGuest => id == 'user_guest';

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.planName,
    required this.monthlyPayment,
    required this.dataUsage,
    required this.dataLimit,
  });

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

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, plan: $planName}';
  }
}