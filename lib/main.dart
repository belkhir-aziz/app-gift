import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/pages/authentication/signin.dart';
import 'package:namer_app/providers/my_app_state.dart';
import 'package:namer_app/services/profile_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCYcLsBJ8rXcb2fNjmv1bE1Gqg1VHFe1pk',
      appId: '1:974866864003:android:c8edf5cad9815428d188b6',
      messagingSenderId: '974866864003',
      projectId: 'giftme-bf341',
      // Add other necessary options
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => MyAppState()), // Provides MyAppState
        ChangeNotifierProvider(
            create: (context) => ProfileProvider()), // Provides ProfileProvider
      ],
      child: MaterialApp(
        title: 'giftme',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFCD6600)),
        ),
        home: SignInScreen(),
      ),
    );
  }
}
