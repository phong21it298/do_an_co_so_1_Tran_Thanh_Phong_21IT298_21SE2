import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_03/viewmodels/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.login(
        emailController.text,
        passwordController.text
    );

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng nhập thất bại"))
      );
    }
  }

  //Widget hỗ trợ tạo ô nhập liệu theo phong cách mới.
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Nền trắng
        borderRadius: BorderRadius.circular(15), // Bo góc
        border: Border.all(color: Colors.black87, width: 1.5), // Viền đen
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.black87),
          suffixIcon: suffixIcon,
          border: InputBorder.none, // Bỏ viền mặc định của TextField
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          //1. Ảnh nền (Background).
          Positioned.fill(
            child: Image.asset(
              'assets/images/kumiko.png',
              fit: BoxFit.cover,
            ),
          ),

          //Lớp phủ mờ nhẹ nếu ảnh quá sáng (tùy chọn).
          //Positioned.fill(child: Container(color: Colors.black.withOpacity(0.1))),

          //2. Nội dung Form.
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Tiêu đề.
                    const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFamily: 'Serif', //Font có chân giống ảnh.
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    //Ô Email.
                    _buildCustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Vui lòng nhập email';

                        final emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

                        if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ';

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    //Ô Password.
                    _buildCustomTextField(
                      controller: passwordController,
                      hintText: "Mật khẩu",
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black54,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';

                        if (value.length < 6) return 'Mật khẩu phải ít nhất 6 ký tự';

                        final hasUppercase = value.contains(RegExp(r'[A-Z]'));
                        final hasLowercase = value.contains(RegExp(r'[a-z]'));
                        final hasDigit = value.contains(RegExp(r'\d'));
                        final hasSpecialChar = value.contains(RegExp(r'[!@#\$&*~]'));

                        if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecialChar) {
                          return 'Mật khẩu nên có chữ hoa, thường, số và ký tự đặc biệt';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    //Nút Đăng nhập.
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF69B4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    //Footer: Chưa có tài khoản?.
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9), // Nền trắng mờ cho khu vực footer
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Chỉ chiếm diện tích vừa đủ
                        children: [
                          const Text(
                            "Chưa có tài khoản?",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),

                          // Nút Tạo tài khoản mới (Màu xanh cốm)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAED581), // Màu xanh
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              minimumSize: const Size(0, 36), // Làm nút nhỏ gọn hơn chút
                            ),
                            child: const Text("Tạo tài khoản mới"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

