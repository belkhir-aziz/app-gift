import 'package:flutter/material.dart';

class LinkProfileWidget extends StatelessWidget {
  final TextEditingController secretKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Link Profile'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('To link this profile, enter the secret key:'),
          SizedBox(height: 16.0),
          TextField(
            controller: secretKeyController,
            decoration: InputDecoration(labelText: 'Secret Key'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement logic to handle the linking process with the secret key
            String secretKey = secretKeyController.text;
            // Add your custom logic here to handle the linking process
            // You can check if the secret key is valid and link the profile accordingly
            // For example, you can call profileProvider.linkProfile(profile.id, secretKey);
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Link'),
        ),
      ],
    );
  }
}
