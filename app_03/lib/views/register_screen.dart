import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_03/viewmodels/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thành công")),
      );
      Navigator.pop(context); //Quay về LoginScreen.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thất bại")),
      );
    }
  }

  //Widget hỗ trợ tạo ô nhập liệu theo phong cách mới.
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
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
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText, // Đưa label thành hint text bên trong
          prefixIcon: Icon(icon, color: Colors.black87),
          suffixIcon: suffixIcon,
          border: InputBorder.none, // Bỏ viền mặc định
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

          //1. Ảnh nền.
          Positioned.fill(
            child: Image.asset(
              'assets/images/kumiko.png',
              fit: BoxFit.cover,
            ),
          ),

          //2. Nút Back ở góc trên trái.
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          //3. Nội dung Form.
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  //Tiêu đề "Tạo tài khoản".
                    const Text(
                      "Tạo tài khoản",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // Màu đỏ
                        fontFamily: 'Serif',
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2.0,
                            color: Colors.white, // Viền bóng trắng cho dễ đọc
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    //Ô Họ và tên.
                    _buildCustomTextField(
                      controller: nameController,
                      hintText: "Họ và tên",
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Vui lòng nhập họ tên';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    //Ô Email.
                    _buildCustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Vui lòng nhập email';

                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                        if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ';

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    //Ô Mật khẩu.
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

                    const SizedBox(height: 30),

                    //Nút Đăng ký.
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF69B4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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
