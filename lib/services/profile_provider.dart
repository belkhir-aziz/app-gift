import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileProvider extends ChangeNotifier {
  static const String dbName = 'community';
  static const String idField = 'id';

  List<Profile> profiles = [];

  Future<void> addProfile(Profile profile) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      profiles.add(profile);

      final docUser = FirebaseFirestore.instance.collection(dbName);
      final json = profile.toJson();
      json['userId'] = user.uid; // Associate the profile with the user's UID
      await docUser.add(json);

      notifyListeners();
    } else {
      print('User not logged in.');
    }
  }

  Future<void> updateProfile(String profileId, Profile updatedProfile) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final querySnapshot = await _getProfileQuery(profileId, user.uid);

      if (querySnapshot.docs.isNotEmpty) {
        final docUser = querySnapshot.docs.first.reference;
        await docUser.update(updatedProfile.toJson());

        _updateLocalProfileList(profileId, updatedProfile);
      } else {
        print('Profile with ID $profileId not found.');
      }
    } else {
      print('User not logged in.');
    }
  }

  Future<void> removeProfile(String profileId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final querySnapshot = await _getProfileQuery(profileId, user.uid);

      if (querySnapshot.docs.isNotEmpty) {
        final docUser = querySnapshot.docs.first.reference;
        await docUser.delete();

        _updateLocalProfileList(profileId, null);
      } else {
        print('Profile with ID $profileId not found.');
      }
    } else {
      print('User not logged in.');
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getProfileQuery(
      String profileId, String userId) async {
    return await FirebaseFirestore.instance
        .collection(dbName)
        .where(idField, isEqualTo: profileId)
        .where('userId', isEqualTo: userId)
        .get();
  }

  void _updateLocalProfileList(String profileId, Profile? updatedProfile) {
    final index = profiles.indexWhere((profile) => profile.id == profileId);
    if (index != -1) {
      if (updatedProfile != null) {
        profiles[index] = updatedProfile;
      } else {
        profiles.removeAt(index);
      }
      notifyListeners();
    }
  }

  Future<void> loadProfiles() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection(dbName)
          .where('userId', isEqualTo: user?.uid)
          .get();

      profiles =
          snapshot.docs.map((doc) => Profile.fromJson(doc.data())).toList();
      notifyListeners();
    } else {
      print('User not logged in.');
    }
  }

  Future<void> initializeProfiles() async {
    if (profiles.isEmpty) {
      await loadProfiles();
    }
    // Now, you can access the profiles from profileProvider.profiles
  }
}
