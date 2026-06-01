import 'package:social_app/models/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUsers(String query);
}
