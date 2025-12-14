import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../community/controllers/quiz_controller.dart';
import '../../community/views/quiz_view.dart';

class CreatorHomeController extends GetxController {
  final String villageName;
  final String? villageId;

  CreatorHomeController({required this.villageName, this.villageId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<String?> resolvedVillageId = Rx<String?>(null);
  final RxBool isLoading = true.obs;

  // 주민 친밀도 데이터
  final RxList<Map<String, dynamic>> memberRankings = <Map<String, dynamic>>[].obs;

  // 임시 퀴즈 정답 데이터
  final RxList<Map<String, dynamic>> recentQuizzes = <Map<String, dynamic>>[
    {'question': 'Q. 김지수의 MBTI는?', 'answer': 'A. ESTP', 'date': '2025.11.25'},
    {'question': 'Q. 김지수의 생일은?', 'answer': 'A. 8월 25일', 'date': '2025.11.23'},
    {'question': 'Q. 김지수의 별자리는?', 'answer': 'A. 처녀자리', 'date': '2025.11.10'},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _resolveVillageId();
  }

  Future<void> _resolveVillageId() async {
    if (villageId != null && villageId!.isNotEmpty) {
      resolvedVillageId.value = villageId;
      await loadMemberRankings();
      isLoading.value = false;
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('villages')
          .where('name', isEqualTo: villageName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        resolvedVillageId.value = querySnapshot.docs.first.id;
        await loadMemberRankings();
      }
      isLoading.value = false;
    } catch (e) {
      print('마을 ID 조회 오류: $e');
      isLoading.value = false;
    }
  }

  Future<void> loadMemberRankings() async {
    if (resolvedVillageId.value == null) return;

    try {
      // 멤버 목록 가져오기
      final membersSnapshot = await _firestore
          .collection('villages')
          .doc(resolvedVillageId.value)
          .collection('members')
          .get();

      List<Map<String, dynamic>> members = [];

      for (var memberDoc in membersSnapshot.docs) {
        final userId = memberDoc.id;
        final memberData = memberDoc.data();
        
        // 사용자 정보 가져오기
        final userDoc = await _firestore.collection('users').doc(userId).get();
        
        if (userDoc.exists) {
          final userData = userDoc.data();
          final intimacy = memberData['intimacy'] ?? 0.0;
          
          members.add({
            'userId': userId,
            'name': userData?['name'] ?? userData?['displayName'] ?? '알 수 없음',
            'title': memberData['title'] ?? '✨새로운 주민✨',
            'intimacy': intimacy,
            'intimacyPercent': (intimacy * 100).round(),
          });
        }
      }

      // 친밀도 순으로 정렬
      members.sort((a, b) => b['intimacy'].compareTo(a['intimacy']));

      // 순위 추가 및 상위 5명만 표시
      final topMembers = members.take(5).toList();
      for (int i = 0; i < topMembers.length; i++) {
        topMembers[i]['rank'] = '${i + 1}위';
      }

      memberRankings.value = topMembers;
    } catch (e) {
      print('주민 친밀도 순위 로드 오류: $e');
    }
  }

  void goBack() {
    Get.back();
  }

  void goToQuiz() {
    if (resolvedVillageId.value == null || resolvedVillageId.value!.isEmpty) {
      Get.snackbar('오류', '마을 정보를 불러오는 중입니다');
      return;
    }

    Get.to(
      () => const QuizView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => QuizController(
          villageName: villageName,
          villageId: resolvedVillageId.value!,
        ));
      }),
    );
  }

  void showMemberRankings() {
    Get.snackbar('전체 주민 친밀도 순위', '준비 중입니다.');
  }

  void showQuizAnswers() {
    Get.snackbar('역대 퀴즈 정답', '준비 중입니다.');
  }
}
