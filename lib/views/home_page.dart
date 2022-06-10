import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tryalapp_01/views/zones_reservation.dart';
import 'package:tryalapp_01/views/calendar.dart';
import 'package:tryalapp_01/views/bottom_bar.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          'Iniciaste Sesion Como: ',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          user.email!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), primary: Colors.black),
            child: const Text(
              'Calendario',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarPage()));
            }),
        const SizedBox(height: 30),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), primary: Colors.black),
            child: const Text(
              'Vista',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadDataFromFireStore()));
            }),
        const SizedBox(height: 30),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), primary: Colors.black),
            child: const Text(
              'Bottom Bar',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
            }),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50), primary: Colors.red),
          icon: const Icon(Icons.arrow_back, size: 32),
          label: const Text(
            'Sign Out',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () => FirebaseAuth.instance.signOut(),
        )
      ]),
    );
  }
}
