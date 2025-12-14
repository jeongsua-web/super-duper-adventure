import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDebugController extends GetxController {
  final RxMap<String, dynamic> firebaseStatus = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkFirebaseConnection();
  }

  Future<void> checkFirebaseConnection() async {
    isLoading.value = true;

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

      firebaseStatus.value = {
        'Firebase Initialized': isInitialized,
        'Firebase Apps Count': Firebase.apps.length,
        'Auth Connected': true,
        'Current User': currentUser?.email ?? 'No user logged in',
        'Firestore Connected': firestoreConnected,
        'Firestore Error': firestoreError,
        'Project ID': 'my-maeul-373c4',
        'Auth Provider': auth.app.options.projectId,
      };
    } catch (e) {
      firebaseStatus.value = {
        'Error': e.toString(),
      };
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    checkFirebaseConnection();
  }
}
