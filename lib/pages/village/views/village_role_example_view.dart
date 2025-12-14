import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/village_member.dart';
import '../../../widgets/role_widgets.dart';
import '../controllers/village_role_example_controller.dart';

class VillageRoleExampleView extends GetView<VillageRoleExampleController> {
  const VillageRoleExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('역할 기반 위젯 예시'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '역할 기반 위젯 사용 예시',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '현재 사용자의 역할에 따라 다른 UI를 표시합니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // UserRoleBuilder 예시
            const Text(
              '1. UserRoleBuilder - 역할별 UI 빌드',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            UserRoleBuilder(
              villageId: controller.villageId,
              builder: (context, member) {
                if (member.isCreator) {
                  return _buildCreatorUI(member);
                } else if (member.isAdmin) {
                  return _buildAdminUI(member);
                } else {
                  return _buildMemberUI(member);
                }
              },
            ),

            const SizedBox(height: 24),

            // RoleBasedWidget 예시
            const Text(
              '2. RoleBasedWidget - 조건부 렌더링',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            RoleBasedWidget(
              villageId: controller.villageId,
              requiredPermission: VillagePermission.manageMembers,
              child: Card(
                color: Colors.orange[50],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings,
                          color: Colors.orange, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '이 위젯은 관리자 이상만 볼 수 있습니다.\n(생성자, 관리자에게만 표시)',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            RoleBasedWidget(
              villageId: controller.villageId,
              requiredPermission: VillagePermission.deleteVillage,
              child: Card(
                color: Colors.red[50],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.red, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '이 위젯은 생성자만 볼 수 있습니다.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // RoleBadge 예시
            const Text(
              '3. RoleBadge - 역할 배지 표시',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '사용자 역할 배지:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    UserRoleBuilder(
                      villageId: controller.villageId,
                      builder: (context, member) => RoleBadge(role: member.role),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // RoleActionButton 예시
            const Text(
              '4. RoleActionButton - 권한 기반 버튼',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '권한에 따라 버튼이 활성화/비활성화됩니다:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    RoleActionButton(
                      villageId: controller.villageId,
                      requiredPermission: VillagePermission.manageMembers,
                      icon: Icons.people,
                      label: '멤버 관리 (관리자 이상)',
                      onPressed: () {
                        controller.showRoleInfo(
                          '멤버 관리',
                          '멤버 관리 기능을 실행합니다.',
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    RoleActionButton(
                      villageId: controller.villageId,
                      requiredPermission: VillagePermission.deleteVillage,
                      icon: Icons.delete_forever,
                      label: '마을 삭제 (생성자 전용)',
                      onPressed: () {
                        controller.showRoleInfo(
                          '마을 삭제',
                          '마을 삭제 기능을 실행합니다.',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorUI(VillageMember member) {
    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName ?? member.userId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '생성자',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              '보유 권한:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('멤버 관리'),
                _buildFeatureChip('초대 생성'),
                _buildFeatureChip('관리자 지정'),
                _buildFeatureChip('마을 설정 변경'),
                _buildFeatureChip('마을 삭제'),
                _buildFeatureChip('모든 권한'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminUI(VillageMember member) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.admin_panel_settings,
                    color: Colors.blue, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName ?? member.userId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '관리자',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              '보유 권한:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('멤버 관리'),
                _buildFeatureChip('초대 생성'),
                _buildFeatureChip('게시글 관리'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberUI(VillageMember member) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.grey, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName ?? member.userId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '일반 멤버',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              '보유 권한:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('게시글 작성'),
                _buildFeatureChip('댓글 작성'),
                _buildFeatureChip('채팅 참여'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
