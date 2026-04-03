import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../utils/theme.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Listen for auth state — navigate as soon as user is signed in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(authStateProvider, (_, next) {
        next.whenData((user) {
          if (user != null && mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty) return 'Please enter your email.';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Please enter a valid email address.';
    }
    if (pass.isEmpty) return 'Please enter your password.';
    if (!_isLogin && pass.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  Future<void> _submit() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final fb = ref.read(firebaseServiceProvider);
      if (_isLogin) {
        await fb.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
      } else {
        await fb.signUpWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
      }
      // Navigation is handled by the authStateProvider listener above
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _error = _friendlyError(e.toString());
          _loading = false;
        });
      }
    }
  }

  Future<void> _guestLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(firebaseServiceProvider).signInAnonymously();
      // Navigation handled by authStateProvider listener
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _error = _friendlyError(e.toString());
          _loading = false;
        });
      }
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('user-not-found') ||
        raw.contains('wrong-password') ||
        raw.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    }
    if (raw.contains('email-already-in-use')) {
      return 'An account with this email already exists.';
    }
    if (raw.contains('weak-password')) {
      return 'Password is too weak. Use at least 6 characters.';
    }
    if (raw.contains('invalid-email')) {
      return 'Invalid email address.';
    }
    if (raw.contains('network-request-failed')) {
      return 'No internet connection. Check your network.';
    }
    if (raw.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    }
    // Strip Firebase noise
    return raw
        .replaceAll(RegExp(r'\[.*?\]'), '')
        .replaceAll('Exception:', '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.kAccent.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.health_and_safety_rounded,
                      color: Colors.white, size: 44),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              ),
              const SizedBox(height: 20),
              Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF80DEEA),
                      Color(0xFF4FC3F7),
                      Color(0xFFE1F5FE)
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'SimpLY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ),
              Center(
                child: Text(
                  'AI Health Triage',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(letterSpacing: 2),
                ).animate().fadeIn(delay: 300.ms),
              ),
              const SizedBox(height: 40),

              // Sign In / Sign Up toggle
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.kCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.kBorder),
                ),
                child: Row(
                  children: [
                    _tab(
                        'Sign In',
                        _isLogin,
                        () => setState(() {
                              _isLogin = true;
                              _error = null;
                            })),
                    _tab(
                        'Sign Up',
                        !_isLogin,
                        () => setState(() {
                              _isLogin = false;
                              _error = null;
                            })),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 24),

              // Email field
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                style: const TextStyle(color: AppTheme.kTextPrimary),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined,
                      color: AppTheme.kTextSecondary),
                ),
                onChanged: (_) => setState(() => _error = null),
              ).animate().fadeIn(delay: 450.ms),
              const SizedBox(height: 12),

              // Password field
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                style: const TextStyle(color: AppTheme.kTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppTheme.kTextSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.kTextSecondary,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) => _submit(),
              ).animate().fadeIn(delay: 500.ms),

              // Error banner
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.kHigh.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppTheme.kHigh.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppTheme.kHigh, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!,
                            style: const TextStyle(
                                color: AppTheme.kHigh, fontSize: 13)),
                      ),
                    ],
                  ),
                ).animate().shake(),
              ],

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isLogin ? 'Sign In' : 'Create Account',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ).animate().fadeIn(delay: 550.ms),

              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppTheme.kBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const Expanded(child: Divider(color: AppTheme.kBorder)),
                ],
              ),
              const SizedBox(height: 16),

              // Guest button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : _guestLogin,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Continue as Guest'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.kTextSecondary,
                    side: const BorderSide(color: AppTheme.kBorder),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'For informational purposes only.\nAlways consult a qualified healthcare professional.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 11, color: AppTheme.kTextMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppTheme.kAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : AppTheme.kTextSecondary,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
