import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/village_member.dart';

class VillageRoleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 특정 마을에서 사용자의 역할 가져오기
  Future<VillageMember?> getUserRole(String villageId, String userId) async {
    try {
      final doc = await _firestore
          .collection('villages')
          .doc(villageId)
          .collection('members')
          .doc(userId)
          .get();

      if (doc.exists) {
        return VillageMember.fromMap(doc.data()!, userId, villageId);
      }
      return null;
    } catch (e) {
      print('역할 가져오기 오류: $e');
      return null;
    }
  }

  // 현재 로그인한 사용자의 역할 가져오기
  Future<VillageMember?> getCurrentUserRole(String villageId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return getUserRole(villageId, user.uid);
  }

  // 마을 생성 시 생성자 역할 부여
  Future<void> setCreatorRole(String villageId, String userId) async {
    final member = VillageMember(
      userId: userId,
      villageId: villageId,
      role: VillageRole.creator,
      joinedAt: DateTime.now(),
    );

    await _firestore
        .collection('villages')
        .doc(villageId)
        .collection('members')
        .doc(userId)
        .set(member.toMap());
  }

  // 새 멤버 추가 (기본: 일반 주민)
  Future<void> addMember(
    String villageId,
    String userId, {
    VillageRole role = VillageRole.member,
  }) async {
    final member = VillageMember(
      userId: userId,
      villageId: villageId,
      role: role,
      joinedAt: DateTime.now(),
    );

    await _firestore
        .collection('villages')
        .doc(villageId)
        .collection('members')
        .doc(userId)
        .set(member.toMap());
  }

  // 멤버 역할 변경
  Future<void> updateMemberRole(
    String villageId,
    String userId,
    VillageRole newRole,
  ) async {
    await _firestore
        .collection('villages')
        .doc(villageId)
        .collection('members')
        .doc(userId)
        .update({'role': VillageMember.roleToString(newRole)});
  }

  // 멤버 제거
  Future<void> removeMember(String villageId, String userId) async {
    await _firestore
        .collection('villages')
        .doc(villageId)
        .collection('members')
        .doc(userId)
        .delete();
  }

  // 마을의 모든 멤버 가져오기
  Future<List<VillageMember>> getAllMembers(String villageId) async {
    try {
      final snapshot = await _firestore
          .collection('villages')
          .doc(villageId)
          .collection('members')
          .get();

      return snapshot.docs
          .map((doc) => VillageMember.fromMap(doc.data(), doc.id, villageId))
          .toList();
    } catch (e) {
      print('멤버 목록 가져오기 오류: $e');
      return [];
    }
  }

  // 특정 역할의 멤버만 가져오기
  Future<List<VillageMember>> getMembersByRole(
    String villageId,
    VillageRole role,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('villages')
          .doc(villageId)
          .collection('members')
          .where('role', isEqualTo: VillageMember.roleToString(role))
          .get();

      return snapshot.docs
          .map((doc) => VillageMember.fromMap(doc.data(), doc.id, villageId))
          .toList();
    } catch (e) {
      print('역할별 멤버 가져오기 오류: $e');
      return [];
    }
  }

  // 멤버 수 가져오기
  Future<int> getMemberCount(String villageId) async {
    try {
      final snapshot = await _firestore
          .collection('villages')
          .doc(villageId)
          .collection('members')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('멤버 수 가져오기 오류: $e');
      return 0;
    }
  }

  // 권한 확인
  Future<bool> hasPermission(
    String villageId,
    String userId,
    VillagePermission permission,
  ) async {
    final member = await getUserRole(villageId, userId);
    if (member == null) return false;
    return member.hasPermission(permission);
  }

  // 현재 사용자의 권한 확인
  Future<bool> currentUserHasPermission(
    String villageId,
    VillagePermission permission,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return hasPermission(villageId, user.uid, permission);
  }

  // 멤버 실시간 스트림
  Stream<List<VillageMember>> getMembersStream(String villageId) {
    return _firestore
        .collection('villages')
        .doc(villageId)
        .collection('members')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VillageMember.fromMap(doc.data(), doc.id, villageId))
            .toList());
  }

  // 특정 사용자 역할 실시간 스트림
  Stream<VillageMember?> getUserRoleStream(String villageId, String userId) {
    return _firestore
        .collection('villages')
        .doc(villageId)
        .collection('members')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return VillageMember.fromMap(doc.data()!, userId, villageId);
      }
      return null;
    });
  }
}
