import 'package:flutter/material.dart';
import 'package:namer_app/models/event.dart';
import 'package:uuid/uuid.dart';

class AddEventWidget extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onEventAdded;
  final Event? eventToUpdate;

  AddEventWidget({
    required this.events,
    required this.onEventAdded,
    this.eventToUpdate,
  });

  @override
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  String selectedGiftState = 'done';
  DateTime? selectedBirthday;
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController recipientController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.eventToUpdate != null) {
      eventTypeController.text = widget.eventToUpdate!.eventType;
      recipientController.text = widget.eventToUpdate!.recipient;
      selectedBirthday = widget.eventToUpdate!.date;
      selectedGiftState = widget.eventToUpdate!.giftStatus ?? 'done';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.eventToUpdate != null ? 'Edit Event' : 'Add Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: eventTypeController,
              label: 'Event Type',
            ),
            _buildTextField(
              controller: recipientController,
              label: 'Recipient',
            ),
            _buildDatePickerField(),
            _buildTextField(
              controller: descriptionController,
              label: 'Description',
            ),
            SizedBox(height: 36.0),
            _buildGiftStatusDropdown(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: () async {
        selectedBirthday = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        setState(() {});
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: selectedBirthday != null
                ? selectedBirthday!.toLocal().toString().split(' ')[0]
                : '',
          ),
          decoration: InputDecoration(labelText: 'Date'),
        ),
      ),
    );
  }

  Widget _buildGiftStatusDropdown() {
    return SizedBox(
      child: DropdownButton<String>(
        value: selectedGiftState,
        onChanged: (newValue) {
          print(newValue);
          setState(() {
            selectedGiftState = newValue!;
          });
        },
        items: ['done', 'noGift', 'stillDeciding']
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ),
            )
            .toList(),
      ),
    );
  }

  void _saveEvent() {
    Event newEvent = Event(
      id: widget.eventToUpdate?.id ?? Uuid().v4(),
      eventType: eventTypeController.text,
      recipient: recipientController.text,
      date: selectedBirthday != null
          ? selectedBirthday!.toLocal()
          : DateTime.now(),
      giftStatus: selectedGiftState,
    );

    if (widget.eventToUpdate != null) {
      widget.onEventAdded(newEvent); // Notify parent about the update
    } else {
      widget.onEventAdded(newEvent); // Notify parent about the new event
    }

    Navigator.of(context).pop(); // Close the dialog
  }
}
