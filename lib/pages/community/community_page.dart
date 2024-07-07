import 'package:flutter/material.dart';
import 'package:namer_app/pages/community/add_edit_profile.dart';
import 'package:namer_app/pages/community/link_profile.dart';
import 'package:namer_app/services/profile_provider.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          profileProvider.initializeProfiles();
          var profiles = profileProvider.profiles;
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              var profile = profiles[index];
              return ListTile(
                title: Text(profile.name),
                subtitle: Text(profile.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit,
                          color: Color.fromARGB(255, 216, 163, 17)),
                      onPressed: () {
                        // Navigate to the edit profile screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditProfileScreen(id: profile.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color: Color.fromARGB(255, 80, 5, 3)),
                      onPressed: () {
                        profileProvider.removeProfile(profile.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.link,
                          color: Color.fromARGB(255, 62, 102, 81)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => LinkProfileWidget(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add profile screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditProfileScreen(),
            ),
          );
        },
        child: Icon(Icons.add, color: Color(0xFFCD6600)),
      ),
    );
  }
}
