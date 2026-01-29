import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmPassC = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleRegister() async {
    if (userC.text.isEmpty || passC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username dan Password harus diisi")),
      );
      return;
    }

    if (passC.text != confirmPassC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password tidak cocok"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final error = await auth.register(userC.text.trim(), passC.text.trim());
    setState(() => _isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register berhasil, silakan login")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header isi tombol kembali
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(color: Colors.red),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Kembali',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Bagian form input
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Akun',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sebelum pakai aplikasi ini, daftar dulu ya',
                      style: TextStyle(color: Color(0xFF666666), fontSize: 16),
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
                        hintText: 'Masukkan username',
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
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
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
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
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
                    const SizedBox(height: 16),

                    // Input konfirmasi password
                    const Text(
                      'Konfirmasi Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: confirmPassC,
                      obscureText: _obscureConfirmPassword,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: 'Masukkan ulang password',
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
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
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
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF666666),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tombol daftar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
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
                                'Daftar Akun',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Teks buat yang sudah punya akun
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah ada akun? ',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Login',
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
          ],
        ),
      ),
    );
  }
}
