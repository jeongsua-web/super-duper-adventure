import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 6자리 초대 코드 생성
  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// 초대 코드 생성 및 저장
  Future<String> createInvitation({
    required String villageId,
    required String createdBy,
    Duration? expiresIn,
  }) async {
    String code = _generateInvitationCode();
    
    // 중복 체크 (최대 5회 시도)
    int attempts = 0;
    while (attempts < 5) {
      final existing = await _firestore.collection('invitations').doc(code).get();
      if (!existing.exists) {
        break;
      }
      code = _generateInvitationCode();
      attempts++;
    }

    final expiresAt = expiresIn != null
        ? Timestamp.fromDate(DateTime.now().add(expiresIn))
        : null;

    await _firestore.collection('invitations').doc(code).set({
      'villageId': villageId,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': expiresAt,
      'usedCount': 0,
      'isActive': true,
    });

    return code;
  }

  /// 초대 코드 검증
  Future<Map<String, dynamic>?> validateInvitation(String code) async {
    final doc = await _firestore.collection('invitations').doc(code).get();
    
    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;
    
    // 비활성화된 초대장
    if (data['isActive'] == false) {
      return null;
    }

    // 만료된 초대장
    if (data['expiresAt'] != null) {
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();
      if (DateTime.now().isAfter(expiresAt)) {
        return null;
      }
    }

    return {
      'code': code,
      'villageId': data['villageId'],
      'createdBy': data['createdBy'],
    };
  }

  /// 초대 코드 사용 (카운트 증가)
  Future<void> useInvitation(String code) async {
    await _firestore.collection('invitations').doc(code).update({
      'usedCount': FieldValue.increment(1),
      'lastUsedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 마을의 활성 초대 코드 목록
  Stream<List<Map<String, dynamic>>> getVillageInvitations(String villageId) {
    return _firestore
        .collection('invitations')
        .where('villageId', isEqualTo: villageId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'code': doc.id,
          ...data,
        };
      }).toList();
    });
  }

  /// 초대 코드 비활성화
  Future<void> deactivateInvitation(String code) async {
    await _firestore.collection('invitations').doc(code).update({
      'isActive': false,
    });
  }

  /// 초대 링크 생성 (딥링크 형식)
  String getInvitationLink(String code) {
    // TODO: 실제 딥링크 도메인으로 변경 필요
    return 'https://mymaeul.app/invite/$code';
  }
}
