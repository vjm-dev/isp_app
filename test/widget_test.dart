// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:isp_app/core/utils/cache_handlers.dart';
import 'package:isp_app/core/utils/validators.dart';
import 'package:isp_app/data/models/user_model.dart';
import 'package:isp_app/domain/entities/data_usage.dart';

void main() {
  test('email validator should return false for invalid emails', () {
    expect(Validators.email('invalid'), false);
    expect(Validators.email('test@'), false);
    expect(Validators.email('test@domain'), false);
  });

  test('email validator should return true for valid emails', () {
    expect(Validators.email('valid@mail.com'), true);
    expect(Validators.email('test@test.net'), true);
    expect(Validators.email('test@domain.xyz'), true);
  });

  test('cache should be considered expired after 1 hour', () {
    final oldUser = UserModel(
      id: '1',
      name: 'whatever',
      email: 'whatever@some.one',
      phone: '+1234567890',
      planName: 'Internet 100 Mbps',
      monthlyPayment: 29.99,
      dataUsage: DataUsage(
        startDate: DateTime.now().subtract(Duration(days: 30)),
        endDate: DateTime.now().add(Duration(days: 5)),
        used: 325.6,
        limit: 1000.0,
        dailyUsage: List.generate(30, (index) {
          final date = DateTime.now().subtract(Duration(days: 29 - index));
          return DataConsumption(
            date: date,
            download: (index % 5 + 2.5),
            upload: (index % 3 + 0.5),
          );
        }),
      ),
      lastUpdated: DateTime.now().subtract(Duration(hours: 2)),
    );
    expect(CacheHandlers.isCacheExpired(oldUser), true);
  });
}
