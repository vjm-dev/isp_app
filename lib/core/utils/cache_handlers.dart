
import 'package:isp_app/data/models/user_model.dart';

class CacheHandlers {
  // Expires after one hour
  static bool isCacheExpired(UserModel user) {
    return DateTime.now().difference(user.lastUpdated) > Duration(hours: 1);
  }
}