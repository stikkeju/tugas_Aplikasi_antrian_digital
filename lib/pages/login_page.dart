import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'admin_dashboard.dart';
import 'customer_main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (userC.text.isEmpty || passC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username dan Password harus diisi")),
      );
      return;
    }
    setState(() => _isLoading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(userC.text.trim(), passC.text.trim());
    setState(() => _isLoading = false);
    if (success) {
      if (auth.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CustomerMainPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal. Periksa username dan password."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo aplikasi
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/logo_mixue.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Judul aplikasi
                Center(
                  child: const Text(
                    'myMixue',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: const Text(
                    'Bukankah ini my.. Mixue? Aplikasi antrian Mixue!',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),

                // Input username
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: userC,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Input password
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passC,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password',
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF666666),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Bagian buat daftar akun baru
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum punya akun? ",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
