import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Realtime Database Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbInstance = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://lmit-demo-flutter-assignment-default-rtdb.asia-southeast1.firebasedatabase.app/').ref();
  var users;

  @override
  void initState() {
    super.initState();

    // Listen for data changes in the database
    dbInstance.child('users').onValue.listen((event) {
      setState(() {
        users = event.snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Realtime Database Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Write data to the database
                var newRecordRef = dbInstance.child('users').push();
                newRecordRef.set({
                  'name': 'John Doe',
                  'email': 'johnDoe@example.com',
                });              },
              child: const Text('Write to Database'),
            ),
            const SizedBox(height: 20),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Text('Data from Database: ${users.toString()}', maxLines: 20,),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
