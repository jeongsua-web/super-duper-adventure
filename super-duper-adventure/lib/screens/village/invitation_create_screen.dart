import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/invitation_service.dart';
import '../../models/village_member.dart';
import '../../services/village_role_service.dart';

class InvitationCreateScreen extends StatefulWidget {
  final String villageId;
  final String villageName;

  const InvitationCreateScreen({
    super.key,
    required this.villageId,
    required this.villageName,
  });

  @override
  State<InvitationCreateScreen> createState() => _InvitationCreateScreenState();
}

class _InvitationCreateScreenState extends State<InvitationCreateScreen> {
  final InvitationService _invitationService = InvitationService();
  final VillageRoleService _roleService = VillageRoleService();
  String? _generatedCode;
  bool _isLoading = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final role = await _roleService.getUserRole(widget.villageId, user.uid);
    setState(() {
      _hasPermission = role?.hasPermission(VillagePermission.inviteMembers) ?? false;
    });
  }

  Future<void> _generateInvitationCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final code = await _invitationService.createInvitation(
        villageId: widget.villageId,
        createdBy: user.uid,
        expiresIn: const Duration(days: 7), // 7일 후 만료
      );

      setState(() {
        _generatedCode = code;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초대 코드 생성 실패: $e')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_generatedCode != null) {
      Clipboard.setData(ClipboardData(text: _generatedCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('초대 코드가 복사되었습니다')),
      );
    }
  }

  void _shareInvitationLink() {
    if (_generatedCode != null) {
      final link = _invitationService.getInvitationLink(_generatedCode!);
      Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('초대 링크가 복사되었습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            '초대 코드 생성',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gowun Dodum',
            ),
          ),
        ),
        body: const Center(
          child: Text(
            '초대 코드를 생성할 권한이 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Gowun Dodum',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${widget.villageName} 초대',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Gowun Dodum',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              '마을에 초대할\n초대 코드를 생성하세요',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Gowun Dodum',
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '초대 코드는 7일간 유효합니다',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Gowun Dodum',
              ),
            ),
            const SizedBox(height: 40),

            // 초대 코드 생성 버튼
            if (_generatedCode == null)
              ElevatedButton(
                onPressed: _isLoading ? null : _generateInvitationCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC4ECF6),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Text(
                        '초대 코드 생성하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

            // 생성된 초대 코드 표시
            if (_generatedCode != null) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFC4ECF6),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      '초대 코드',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: 'Gowun Dodum',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _generatedCode!,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        fontFamily: 'Courier New',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _copyToClipboard,
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('복사'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black26),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _shareInvitationLink,
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('링크 공유'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC4ECF6),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generatedCode = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '새 코드 생성',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Gowun Dodum',
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),

            // 안내 사항
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        '초대 코드 안내',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                          fontFamily: 'Gowun Dodum',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• 초대 코드는 7일간 유효합니다\n'
                    '• 여러 사람이 같은 코드로 입주할 수 있습니다\n'
                    '• 초대 코드 목록에서 관리할 수 있습니다',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.6,
                      fontFamily: 'Gowun Dodum',
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 초대 코드 목록 버튼
            TextButton.icon(
              onPressed: () {
                // TODO: 초대 코드 목록 화면으로 이동
              },
              icon: const Icon(Icons.list),
              label: const Text('생성된 초대 코드 목록'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
