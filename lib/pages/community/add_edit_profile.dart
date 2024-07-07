import 'package:flutter/material.dart';
import 'package:namer_app/models/profile.dart';
import 'package:namer_app/services/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final String profileId;

  // Constructor for adding a new profile or editing an existing one
  AddEditProfileScreen({String? id})
      : profileId = id ??
            Uuid()
                .v4(), // Use provided id if available, otherwise generate a new one
        super();

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    // Retrieve the existing profile if editing
    Profile? existingProfile;
    if (profileId.isNotEmpty) {
      for (var profile in profileProvider.profiles) {
        if (profile.id == profileId) {
          existingProfile = profile;
          break;
        }
      }
      if (existingProfile != null) {
        // If editing, populate the text fields with the existing profile data
        nameController.text = existingProfile.name;
        emailController.text = existingProfile.email;
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(existingProfile != null ? 'Edit Profile' : 'Add Profile'),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save or update the profile
                String name = nameController.text;
                String email = emailController.text;

                // Perform validation if necessary

                // Check if editing an existing profile or adding a new one
                if (existingProfile != null) {
                  // Editing an existing profile
                  profileProvider.updateProfile(profileId,
                      Profile(id: profileId, name: name, email: email));
                } else {
                  // Adding a new profile
                  profileProvider.addProfile(
                      Profile(id: profileId, name: name, email: email));
                }

                // Close the screen
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
