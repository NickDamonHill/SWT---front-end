import 'package:flutter/material.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Color(0xFFD4C4B5),
                ),
                const SizedBox(height: 48),
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
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // Hier Passwort vergessen Logik implementieren
                  },
                  child: const Text(
                    'Passwort vergessen?',
                    style: TextStyle(
                      color: Color(0xFF8B7355),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Hier können Sie die Login-Logik implementieren
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
                    'Anmelden',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Noch kein Konto?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Registrieren',
                        style: TextStyle(
                          color: Color(0xFF8B7355),
                          fontWeight: FontWeight.bold,
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
  }
}