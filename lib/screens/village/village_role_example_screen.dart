import 'package:flutter/material.dart';
import '../models/village_member.dart';
import '../widgets/role_widgets.dart';

/// 역할 기반 UI 사용 예시
class VillageRoleExampleScreen extends StatelessWidget {
  final String villageId;

  const VillageRoleExampleScreen({
    super.key,
    required this.villageId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('역할 기반 UI 예시'),
        actions: [
          // 생성자만 볼 수 있는 설정 버튼
          RoleBasedWidget(
            villageId: villageId,
            requiredPermission: VillagePermission.editVillageSettings,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // 마을 설정 화면으로 이동
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 사용자의 역할 표시
            UserRoleBuilder(
              villageId: villageId,
              builder: (context, member) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 40),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '내 역할',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RoleBadge(role: member.role, fontSize: 14),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            const Text(
              '권한별 기능',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 생성자 전용 버튼
            RoleActionButton(
              villageId: villageId,
              requiredPermission: VillagePermission.deleteVillage,
              icon: Icons.delete_forever,
              label: '마을 삭제 (생성자만)',
              color: Colors.red[100],
              onPressed: () {
                // 마을 삭제 확인 다이얼로그
              },
            ),
            const SizedBox(height: 8),

            // 관리자 이상 버튼
            RoleActionButton(
              villageId: villageId,
              requiredPermission: VillagePermission.manageMembers,
              icon: Icons.group,
              label: '멤버 관리 (관리자 이상)',
              onPressed: () {
                // 멤버 관리 화면으로 이동
              },
            ),
            const SizedBox(height: 8),

            // 모든 멤버 버튼
            RoleActionButton(
              villageId: villageId,
              requiredPermission: VillagePermission.createComment,
              icon: Icons.comment,
              label: '댓글 작성 (모든 멤버)',
              onPressed: () {
                // 댓글 작성
              },
            ),

            const SizedBox(height: 24),

            // 조건부 UI 렌더링 예시
            UserRoleBuilder(
              villageId: villageId,
              builder: (context, member) {
                if (member.isCreator) {
                  return _buildCreatorUI();
                } else if (member.isAdmin) {
                  return _buildAdminUI();
                } else {
                  return _buildMemberUI();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 생성자 전용 UI
  Widget _buildCreatorUI() {
    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.star, size: 40, color: Colors.amber),
            const SizedBox(height: 8),
            const Text(
              '마을 생성자',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '모든 권한을 가지고 있습니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('마을 설정 변경'),
                _buildFeatureChip('마을 삭제'),
                _buildFeatureChip('멤버 관리'),
                _buildFeatureChip('관리자 지정'),
                _buildFeatureChip('공지사항 작성'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 관리자 전용 UI
  Widget _buildAdminUI() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.admin_panel_settings, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            const Text(
              '관리자',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '멤버 관리 및 콘텐츠 관리 권한이 있습니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('멤버 초대/강퇴'),
                _buildFeatureChip('게시글 관리'),
                _buildFeatureChip('이벤트 생성'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 일반 주민 UI
  Widget _buildMemberUI() {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.person, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            const Text(
              '주민',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '마을 활동에 참여할 수 있습니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('게시글 보기'),
                _buildFeatureChip('댓글 작성'),
                _buildFeatureChip('이벤트 참여'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 11),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Colors.grey, width: 0.5),
    );
  }
}
