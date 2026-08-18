import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/wave_clipper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Vérification des champs
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    // Activer le loading
    setState(() => _isLoading = true);

    // Simulation d'une vérification
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Connexion administrateur
    if (email == 'admin@eni.fr' && password == 'admin') {
      setState(() => _isLoading = false);

      context.go('/home');
      return;
    }

    // Connexion professeur
    if (email == 'prof@eni.fr' && password == 'prof') {
      setState(() => _isLoading = false);

      context.go('/teachers');
      return;
    }

    // Identifiants incorrects
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Identifiants incorrects.')));
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: AppColors.eniGreen,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ---------- Cercles décoratifs en bas ----------
            Positioned(
              bottom: -60,
              left: -30,
              child: _decoCircle(110, AppColors.eniGreenLight),
            ),
            Positioned(
              bottom: 20,
              left: 130,
              child: _decoCircle(40, AppColors.eniGreenLight),
            ),

            Column(
              children: [
                // Photo du bâtiment ENI avec vague verte qui la recouvre
                SizedBox(
                  height: keyboardHeight > 0 ? 150 : 250,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/eni_building.jpg',
                        fit: BoxFit.cover,
                      ),
                      // Fondu blanc en haut de la photo
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: [Colors.white, Colors.transparent],
                          ),
                        ),
                      ),
                      // Vague verte qui mord sur le bas de la photo
                      ClipPath(
                        clipper: WaveClipper(),
                        child: Container(color: AppColors.eniGreen),
                      ),
                    ],
                  ),
                ),

                // ---------- Formulaire ----------
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connexion',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                              ),
                        ),
                        const SizedBox(height: 28),

                        _FieldLabel('Email'),
                        const SizedBox(height: 8),
                        _AuthTextField(
                          controller: _emailController,
                          icon: Icons.mail_outline,
                          hintText: "example@gmail.com",
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),

                        _FieldLabel('Mot de passe'),
                        const SizedBox(height: 8),
                        _AuthTextField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hintText: ".......",
                          isEmail: false,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.iconGrey,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.eniGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 20,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: AppColors.eniGreen,
                                    ),
                                  )
                                : const Text(
                                    'Se connecter',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _decoCircle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 5),
        ),
      ],
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    ),
  );
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final bool isEmail;
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _AuthTextField({
    required this.controller,
    required this.icon,
    required this.hintText,
    this.isEmail = true,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.inputTextGrey, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.avatarBg,
        prefixIcon: Icon(icon, color: AppColors.iconGrey, size: 21),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.iconGrey, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
