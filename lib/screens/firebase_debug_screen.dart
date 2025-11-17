import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDebugScreen extends StatefulWidget {
  const FirebaseDebugScreen({super.key});

  @override
  State<FirebaseDebugScreen> createState() => _FirebaseDebugScreenState();
}

class _FirebaseDebugScreenState extends State<FirebaseDebugScreen> {
  late Map<String, dynamic> _firebaseStatus = {};

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      // Firebase Core 확인
      final isInitialized = Firebase.apps.isNotEmpty;

      // Firebase Auth 확인
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      // Firestore 연결 확인
      final firestore = FirebaseFirestore.instance;
      bool firestoreConnected = false;
      String firestoreError = '';

      try {
        // 간단한 Firestore 쿼리 실행
        await firestore
            .collection('test')
            .limit(1)
            .get()
            .timeout(const Duration(seconds: 5));
        firestoreConnected = true;
      } catch (e) {
        firestoreError = e.toString();
      }

      setState(() {
        _firebaseStatus = {
          'Firebase Initialized': isInitialized,
          'Firebase Apps Count': Firebase.apps.length,
          'Auth Connected': true,
          'Current User': currentUser?.email ?? 'No user logged in',
          'Firestore Connected': firestoreConnected,
          'Firestore Error': firestoreError,
          'Project ID': 'my-maeul-373c4',
          'Auth Provider': auth.app.options.projectId,
        };
      });
    } catch (e) {
      setState(() {
        _firebaseStatus = {
          'Error': e.toString(),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase 연결 상태'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_firebaseStatus.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ..._firebaseStatus.entries.map((entry) {
              final isConnected = entry.value is bool && entry.value == true;
              final isError = entry.key.toLowerCase().contains('error');

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isConnected)
                            const Icon(Icons.check_circle,
                                color: Colors.green)
                          else if (isError)
                            const Icon(Icons.error, color: Colors.red)
                          else
                            const Icon(Icons.info, color: Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.value.toString(),
                        style: TextStyle(
                          color: isError ? Colors.red : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _checkFirebaseConnection,
            child: const Text('새로고침'),
          ),
        ],
      ),
    );
  }
}
