import 'package:flutter/material.dart';
import '../models/village_member.dart';
import '../services/village_role_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 역할에 따라 위젯을 조건부로 표시하는 빌더
class RoleBasedWidget extends StatelessWidget {
  final String villageId;
  final VillagePermission? requiredPermission;
  final VillageRole? requiredRole;
  final Widget child;
  final Widget? fallback;

  const RoleBasedWidget({
    super.key,
    required this.villageId,
    this.requiredPermission,
    this.requiredRole,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return fallback ?? const SizedBox.shrink();
    }

    return StreamBuilder<VillageMember?>(
      stream: VillageRoleService().getUserRoleStream(villageId, user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return fallback ?? const SizedBox.shrink();
        }

        final member = snapshot.data!;
        
        // 권한 확인
        if (requiredPermission != null) {
          if (!member.hasPermission(requiredPermission!)) {
            return fallback ?? const SizedBox.shrink();
          }
        }

        // 역할 확인
        if (requiredRole != null) {
          if (member.role != requiredRole) {
            return fallback ?? const SizedBox.shrink();
          }
        }

        return child;
      },
    );
  }
}

/// 현재 사용자의 역할 정보를 제공하는 빌더
class UserRoleBuilder extends StatelessWidget {
  final String villageId;
  final Widget Function(BuildContext context, VillageMember member) builder;
  final Widget? loading;
  final Widget? noRole;

  const UserRoleBuilder({
    super.key,
    required this.villageId,
    required this.builder,
    this.loading,
    this.noRole,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return noRole ?? const SizedBox.shrink();
    }

    return StreamBuilder<VillageMember?>(
      stream: VillageRoleService().getUserRoleStream(villageId, user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading ?? const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return noRole ?? const SizedBox.shrink();
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}

/// 역할 배지 위젯
class RoleBadge extends StatelessWidget {
  final VillageRole role;
  final double fontSize;

  const RoleBadge({
    super.key,
    required this.role,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;

    switch (role) {
      case VillageRole.creator:
        badgeColor = const Color(0xFFFFD700); // 금색
        badgeText = '생성자';
        break;
      case VillageRole.admin:
        badgeColor = const Color(0xFF4A90E2); // 파란색
        badgeText = '관리자';
        break;
      case VillageRole.member:
        badgeColor = const Color(0xFF95A5A6); // 회색
        badgeText = '주민';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: badgeColor,
          fontFamily: 'Gowun Dodum',
        ),
      ),
    );
  }
}

/// 역할별 액션 버튼 (예: 설정, 멤버 관리 등)
class RoleActionButton extends StatelessWidget {
  final String villageId;
  final VillagePermission requiredPermission;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const RoleActionButton({
    super.key,
    required this.villageId,
    required this.requiredPermission,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      villageId: villageId,
      requiredPermission: requiredPermission,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFC4ECF6),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
