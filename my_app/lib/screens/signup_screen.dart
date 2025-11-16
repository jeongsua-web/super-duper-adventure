import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _idController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;

  final AuthService _authService = AuthService();
  bool _isIdAvailable = false;
  bool _isValidPassword = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _idController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();

    // Password validation listener
    _passwordController.addListener(_validatePassword);
    _passwordConfirmController.addListener(_validatePasswordMatch);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    // Check if password is alphanumeric
    final isValid = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(_passwordController.text);
    setState(() {
      _isValidPassword = isValid;
    });
    _validatePasswordMatch();
  }

  void _validatePasswordMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _passwordConfirmController.text &&
          _passwordController.text.isNotEmpty;
    });
  }

  void _checkIdAvailability() {
    // Simulate ID availability check
    if (_idController.text.isNotEmpty) {
      setState(() {
        _isIdAvailable = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용 가능한 아이디입니다')),
      );
    }
  }

  void _suggestId() {
    // Generate a suggested ID
    final suggestedId = 'user_${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    setState(() {
      _idController.text = suggestedId;
      _isIdAvailable = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('추천 아이디: $suggestedId')),
    );
  }

  Future<void> _handleSignup() async {
    // Validate inputs
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _idController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요')),
      );
      return;
    }

    if (!_isIdAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디 중복확인을 해주세요')),
      );
      return;
    }

    if (!_isValidPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호는 영문, 숫자 조합이어야 합니다')),
      );
      return;
    }

    if (!_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
      );
      return;
    }

    // Firebase signup with email
    final result = await _authService.signUp(
      _emailController.text,
      _passwordController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      
      if (result['success']) {
        // Navigate back to login
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // Name field
                const Text(
                  '이름',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _InputField(
                  controller: _nameController,
                  hintText: '이름 입력',
                ),

                const SizedBox(height: 30),

                // Phone field
                const Text(
                  '전화번호',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _InputField(
                  controller: _phoneController,
                  hintText: '전화번호 입력',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 30),

                // Email field
                const Text(
                  '이메일',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _InputField(
                  controller: _emailController,
                  hintText: '이메일 입력',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 30),

                // ID field with check button
                const Text(
                  '아이디',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _InputField(
                        controller: _idController,
                        hintText: '아이디 입력',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: _checkIdAvailability,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              '중복확인',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ID suggestion button
                GestureDetector(
                  onTap: _suggestId,
                  child: Container(
                    height: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Center(
                      child: Text(
                        '아이디 추천받기',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Password field
                const Text(
                  '비밀번호',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _InputField(
                  controller: _passwordController,
                  hintText: '비밀번호 입력',
                  obscureText: true,
                ),

                const SizedBox(height: 6),

                // Password hint
                Text(
                  _isValidPassword ? '✓ 영문, 숫자 조합' : '영문, 숫자 조합으로 만들어주세요',
                  style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: _isValidPassword ? Colors.green : const Color(0xFF9E9E9E),
                  ),
                ),

                const SizedBox(height: 20),

                // Password confirm field
                const Text(
                  '비밀번호 확인',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _InputField(
                  controller: _passwordConfirmController,
                  hintText: '비밀번호 재입력',
                  obscureText: true,
                ),

                const SizedBox(height: 60),

                // Buttons at bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 89,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            '뒤로 가기',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 30),

                    // Signup button
                    GestureDetector(
                      onTap: _handleSignup,
                      child: Container(
                        width: 89,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            '회원가입 완료',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(2),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
