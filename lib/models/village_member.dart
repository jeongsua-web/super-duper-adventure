enum VillageRole {
  creator, // 마을 생성자 (최고 관리자)
  admin,   // 관리자
  member,  // 일반 주민
}

class VillageMember {
  final String userId;
  final String villageId;
  final VillageRole role;
  final DateTime joinedAt;
  final String? displayName;
  final String? profileImage;

  VillageMember({
    required this.userId,
    required this.villageId,
    required this.role,
    required this.joinedAt,
    this.displayName,
    this.profileImage,
  });

  // Firestore에서 데이터 가져오기
  factory VillageMember.fromMap(Map<String, dynamic> map, String userId, String villageId) {
    return VillageMember(
      userId: userId,
      villageId: villageId,
      role: roleFromString(map['role'] ?? 'member'),
      joinedAt: (map['joinedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      displayName: map['displayName'],
      profileImage: map['profileImage'],
    );
  }

  // Firestore에 저장할 데이터
  Map<String, dynamic> toMap() {
    return {
      'role': roleToString(role),
      'joinedAt': joinedAt,
      'displayName': displayName,
      'profileImage': profileImage,
    };
  }

  // 역할을 문자열로 변환
  static String roleToString(VillageRole role) {
    switch (role) {
      case VillageRole.creator:
        return 'creator';
      case VillageRole.admin:
        return 'admin';
      case VillageRole.member:
        return 'member';
    }
  }

  // 문자열을 역할로 변환
  static VillageRole roleFromString(String role) {
    switch (role) {
      case 'creator':
        return VillageRole.creator;
      case 'admin':
        return VillageRole.admin;
      case 'member':
      default:
        return VillageRole.member;
    }
  }

  // 권한 체크 메서드들
  bool get isCreator => role == VillageRole.creator;
  bool get isAdmin => role == VillageRole.admin || role == VillageRole.creator;
  bool get isMember => role == VillageRole.member;
  
  // 특정 권한이 있는지 확인
  bool hasPermission(VillagePermission permission) {
    switch (permission) {
      case VillagePermission.deleteVillage:
      case VillagePermission.editVillageSettings:
      case VillagePermission.manageVillageSettings:
        return isCreator;
      
      case VillagePermission.manageMembers:
      case VillagePermission.inviteMembers:
      case VillagePermission.createPost:
      case VillagePermission.createEvent:
      case VillagePermission.deleteAnyPost:
        return isAdmin;
      
      case VillagePermission.viewContent:
      case VillagePermission.createComment:
      case VillagePermission.deleteOwnPost:
        return true; // 모든 멤버
    }
  }

  // 역할 이름 한글로 표시
  String get roleDisplayName {
    switch (role) {
      case VillageRole.creator:
        return '마을 생성자';
      case VillageRole.admin:
        return '관리자';
      case VillageRole.member:
        return '주민';
    }
  }

  VillageMember copyWith({
    String? userId,
    String? villageId,
    VillageRole? role,
    DateTime? joinedAt,
    String? displayName,
    String? profileImage,
  }) {
    return VillageMember(
      userId: userId ?? this.userId,
      villageId: villageId ?? this.villageId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      displayName: displayName ?? this.displayName,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

// 마을 권한 열거형
enum VillagePermission {
  // 생성자 전용
  deleteVillage,           // 마을 삭제
  editVillageSettings,     // 마을 설정 수정
  manageVillageSettings,   // 마을 설정 관리
  
  // 관리자 이상
  manageMembers,           // 멤버 관리 (초대, 강퇴, 역할 변경)
  inviteMembers,           // 멤버 초대
  createPost,              // 공지사항 작성
  createEvent,             // 이벤트 생성
  deleteAnyPost,           // 다른 사람 게시글 삭제
  
  // 모든 멤버
  viewContent,             // 콘텐츠 보기
  createComment,           // 댓글 작성
  deleteOwnPost,           // 본인 게시글 삭제
}
