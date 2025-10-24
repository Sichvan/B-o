// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart'; // <-- Import l10n

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // --- HÀM THÔNG BÁO LỖI (ĐÃ CẬP NHẬT) ---
  void _showErrorDialog(BuildContext ctx, String message) {
    final l10n = AppLocalizations.of(ctx)!;
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.errorTitle), // <-- Dùng l10n
        content: Text(message),
        actions: [
          TextButton(
            child: Text(l10n.ok), // <-- Dùng l10n
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  // --- HÀM THÔNG BÁO ĐĂNG KÝ THÀNH CÔNG (MỚI) ---
  void _showSuccessDialog(BuildContext ctx, String message) {
    final l10n = AppLocalizations.of(ctx)!;
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.registrationSuccessTitle), // <-- Dùng l10n
        content: Text(l10n.registrationSuccessMessage), // <-- Dùng l10n
        actions: [
          TextButton(
            child: Text(l10n.ok),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  // --- HÀM SUBMIT (ĐÃ SỬA LỖI LOGIC) ---
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return; // Không hợp lệ
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (_isLogin) {
        // --- LOGIC ĐĂNG NHẬP ---
        await authProvider.login(
            _emailController.text, _passwordController.text);
        if (mounted) {
          Navigator.of(context).pop(); // Đóng màn hình AuthScreen
        }
      } else {
        // --- LOGIC ĐĂNG KÝ ---
        await authProvider.register(
            _emailController.text, _passwordController.text);
        if (mounted) {
          Navigator.of(context).pop();
        }
        if (mounted) {
          setState(() => _isLoading = false);
          _showSuccessDialog(context, "Đăng ký thành công");
          // Tự động chuyển về tab đăng nhập
          setState(() => _isLogin = true);
        }
      }
    } catch (error) {
      // Nếu có lỗi (login hoặc register), chúng ta VẪN Ở LẠI
      // -> CÓ THỂ gọi setState.
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorDialog(context, error.toString());
      }
    }
    // *** Chúng ta KHÔNG gọi setState ở đây nữa ***
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- GIAO DIỆN MỚI ---
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // AppBar đồng bộ với theme
      appBar: AppBar(
        title: Text(_isLogin ? l10n.login : l10n.register),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        // Thêm gradient cho đẹp mắt
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20.0),
                width: deviceSize.width * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tiêu đề
                      Text(
                        _isLogin ? l10n.login : l10n.register,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return l10n.emailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return l10n.passwordInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Nút Submit
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              _isLogin ? l10n.login.toUpperCase() : l10n.register.toUpperCase(),
                            ),
                          ),
                        ),

                      // Nút chuyển đổi
                      TextButton(
                        onPressed: () {
                          setState(() => _isLogin = !_isLogin);
                        },
                        child: Text(
                          _isLogin ? l10n.switchToRegister : l10n.switchToLogin,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}