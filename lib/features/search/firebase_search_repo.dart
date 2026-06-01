import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/search/search_repo.dart';
import 'package:social_app/models/profile_user.dart';

class FirebaseSearchRepo implements SearchRepo{
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async {
    try {
      final queryLower = query.toLowerCase();
      final result = await FirebaseFirestore.instance.collection('users')
      .where('nameLower', isGreaterThanOrEqualTo: queryLower)
      .where('nameLower', isLessThanOrEqualTo: '$queryLower\uf8ff')
      .get();

      return result.docs.map((doc) => ProfileUser.fromMap(doc.data())).toList();
    } catch (e) {
     throw Exception('Error searching users');
    }
  }
}