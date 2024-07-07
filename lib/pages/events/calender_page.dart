import 'package:flutter/material.dart';
import 'package:namer_app/models/event.dart';
import 'package:namer_app/pages/events/add_event_widget.dart';
import 'package:namer_app/services/event_handler.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final EventService eventService = EventService();
  Event? _eventToUpdate;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await eventService.initializeEvents();
    // Additional initialization if needed
    setState(() {
      // Trigger a rebuild after data is loaded
    });
  }

  void _handleEventAdded(Event newEvent) {
    setState(() {
      eventService.addEvent(newEvent);
    });
  }

  void _handleEventDeleted(Event eventToDelete) {
    _deleteEventAndUpdateState(eventToDelete);
  }

  Future<void> _deleteEventAndUpdateState(Event eventToDelete) async {
    // Perform asynchronous operation
    await eventService.removeEvent(eventToDelete);

    // Update the state
    setState(() {
      // Optionally, perform any additional synchronous updates
      // inside the setState block if needed.
    });
  }

  void _handleEventEdit(Event event) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEventWidget(
          events: eventService.events,
          onEventAdded: (Event updatedEvent) async {
            // Update the existing event in the eventService
            await eventService.updateEvent(updatedEvent);

            // Update the state to trigger a rebuild
            setState(() {
              // Optionally, perform any additional synchronous updates
              // inside the setState block if needed.
            });
          },
          eventToUpdate: event,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddEventWidget(
                      events: eventService.events,
                      onEventAdded: (Event newEvent) {
                        _handleEventAdded(newEvent);
                      },
                    );
                  },
                );
              },
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 216, 163, 17)),
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text(
                    'Add Event',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: eventService.events.length,
        itemBuilder: (context, index) {
          Event event = eventService.events[index];
          String giftStatusText =
              _getTextForGiftStatus(event.giftStatus.toString());
          Color giftStatusColor =
              _getColorForGiftStatus(event.giftStatus ?? 'done');

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: ListTile(
                title: Text('${event.eventType} - ${event.recipient}',
                    style: TextStyle(color: Colors.black)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${event.date.toString()}',
                        style: TextStyle(color: Colors.black)),
                    Text(
                      giftStatusText,
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: giftStatusColor),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFFCD6600)),
                      onPressed: () {
                        _handleEventEdit(event);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color: Color.fromARGB(255, 80, 5, 3)),
                      onPressed: () {
                        _handleEventDeleted(event);
                      },
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          );
        },
      ),
    );
  }
}

Color _getColorForGiftStatus(String? status) {
  switch (status) {
    case 'done':
      return Color.fromARGB(255, 45, 173, 49);
    case 'noGift':
      return const Color.fromARGB(255, 99, 24, 18);
    case 'stillDeciding':
      return Color.fromARGB(255, 216, 163, 17);
    default:
      return Color.fromARGB(255, 216, 163, 17);
  }
}

String _getTextForGiftStatus(String? status) {
  switch (status) {
    case 'done':
      return 'Gift is ready';
    case 'noGift':
      return 'No Gift Needed';
    case 'stillDeciding':
      return 'Still deciding';
    default:
      return 'Still deciding';
  }
}
