import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  final String eventType;
  final String recipient;
  final DateTime date;
  String? giftStatus;
  bool isNotificationSent;

  Event({
    this.id = '',
    required this.eventType,
    required this.recipient,
    required this.date,
    this.giftStatus,
    this.isNotificationSent = false,
  });

  Event copyWith({
    String? id,
    String? eventType,
    String? recipient,
    DateTime? date,
    String? giftStatus,
    bool? isNotificationSent,
  }) {
    return Event(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      recipient: recipient ?? this.recipient,
      date: date ?? this.date,
      giftStatus: giftStatus ?? this.giftStatus,
      isNotificationSent: isNotificationSent ?? this.isNotificationSent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventType': eventType,
      'recipient': recipient,
      'date': date.toUtc(),
      'giftStatus': giftStatus,
      'isNotificationSent': isNotificationSent,
    };
  }

  static Event fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        eventType: json['eventType'],
        recipient: json['recipient'],
        date: (json['date'] as Timestamp).toDate(),
        giftStatus: json['giftStatus'],
      );
}
