import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Pendaftaran gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Mendaftarkan akun...',
      child: Scaffold(
        backgroundColor: const Color(0xFFECECEC), // sama dengan login
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Judul ──────────────────────────────────
                          Text(
                            'Sign up',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Lengkapi data diri anda untuk mendaftar.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 32),

                          // ── Field Nama ──────────────────────────────
                          CustomTextField(
                            label: 'Nama Lengkap',
                            hint: 'masukkan nama lengkap',
                            controller: _nameCtrl,
                            prefixIcon: const Icon(Icons.person_outline),
                            validator: (v) => (v?.isEmpty ?? true)
                                ? 'Nama wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // ── Field Email ─────────────────────────────
                          CustomTextField(
                            label: 'Email',
                            hint: 'contoh@email.com',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: (v) {
                              if (v?.isEmpty ?? true)
                                return 'Email wajib diisi';
                              if (!EmailValidator.validate(v!)) {
                                return 'Format email salah';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // ── Field Password ──────────────────────────
                          CustomTextField(
                            label: 'Password',
                            hint: 'minimal 8 karakter',
                            controller: _passCtrl,
                            obscureText: !_showPass,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPass
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _showPass = !_showPass),
                            ),
                            validator: (v) => (v?.length ?? 0) < 8
                                ? 'Password minimal 8 karakter'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // ── Field Konfirmasi Password ───────────────
                          CustomTextField(
                            label: 'Konfirmasi Password',
                            hint: 'masukkan password',
                            controller: _pass2Ctrl,
                            obscureText: !_showPass,
                            prefixIcon: const Icon(Icons.lock_outline),
                            validator: (v) => v != _passCtrl.text
                                ? 'Password tidak cocok'
                                : null,
                          ),
                          const SizedBox(height: 28),

                          // ── Tombol Daftar ───────────────────────────
                          CustomButton(
                            label: 'Sign Up',
                            onPressed: _register,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 20),

                          // ── Link ke Login ───────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? '),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.login,
                                ),
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
