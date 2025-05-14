import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4C4B5),
        title: const Text('Registrierung'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.app_registration,
                  size: 100,
                  color: Color(0xFFD4C4B5),
                ),
                const SizedBox(height: 48),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie eine E-Mail-Adresse ein';
                      }
                      if (!value.contains('@')) {
                        return 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Benutzername',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie einen Benutzernamen ein';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie ein Passwort ein';
                      }
                      if (value.length < 6) {
                        return 'Das Passwort muss mindestens 6 Zeichen lang sein';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Passwort bestätigen',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte bestätigen Sie Ihr Passwort';
                      }
                      if (value != _passwordController.text) {
                        return 'Die Passwörter stimmen nicht überein';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Hier können Sie die Registrierungs-Logik implementieren
                      print('E-Mail: ${_emailController.text}');
                      print('Benutzername: ${_usernameController.text}');
                      print('Passwort: ${_passwordController.text}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4C4B5),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Registrieren',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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