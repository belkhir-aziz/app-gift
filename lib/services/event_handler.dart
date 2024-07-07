import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namer_app/models/event.dart';

class EventService {
  final String collectionName = 'events';
  late FirebaseFirestore _firestore;

  List<Event> events = [];

  EventService() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> _loadEvents() async {
    final snapshot = await _firestore.collection(collectionName).get();
    events = snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList();
  }

  Future<void> initializeEvents() async {
    await _loadEvents();
  }

  Future<void> addEvent(Event event) async {
    events.add(event);
    final docUser = FirebaseFirestore.instance.collection(collectionName);
    final json = event.toJson();
    await docUser.add(json);
  }

  Future<void> updateEvent(Event updatedEvent) async {
    // Find the document based on the custom event ID
    final querySnapshot = await _firestore
        .collection(collectionName)
        .where('id', isEqualTo: updatedEvent.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Update the document in Firestore
      await querySnapshot.docs.first.reference.update(updatedEvent.toJson());

      // Update the event in the local list
      final index = events.indexWhere((event) => event.id == updatedEvent.id);
      if (index != -1) {
        events[index] = updatedEvent;
      }
    }
  }

  Future<void> removeEvent(Event event) async {
    // Find the document based on the custom event ID
    final querySnapshot = await _firestore
        .collection(collectionName)
        .where('id', isEqualTo: event.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Delete the document from Firestore
      await querySnapshot.docs.first.reference.delete();

      // Remove the event from the local list
      events.removeWhere((e) => e.id == event.id);
    }
  }
}
