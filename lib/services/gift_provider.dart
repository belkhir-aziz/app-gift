import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/gift.dart';

class GiftProvider extends ChangeNotifier {
  static const String collectionName = 'gifts';
  late FirebaseFirestore _firestore;

  List<Gift> gifts = [];
  GiftProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> _loadGifts() async {
    final snapshot = await _firestore.collection(collectionName).get();
    gifts = snapshot.docs.map((doc) => Gift.fromJson(doc.data())).toList();
  }

  Future<void> initializeGifts() async {
    await _loadGifts();
  }
}
