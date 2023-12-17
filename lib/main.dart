import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'vistas/login.dart';
import 'firebase_options.dart';
// main

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyARY70xWxdW5UXp9KTfGChLFLHSere_01E",
      authDomain: "verduleria-df26f.firebaseapp.com",
      projectId: "verduleria-df26f",
      storageBucket: "verduleria-df26f.appspot.com",
      messagingSenderId: "617127359597",
      appId: "1:617127359597:web:854bc3b89b4573623ffb64",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
      
      },
    );
  }
}
