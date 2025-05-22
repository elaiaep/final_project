import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass  = TextEditingController();
  bool isLogin = true;
  final _authSvc = AuthService();

  void msg(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m))
  );

  Future<void> _submit() async {
    try {
      if (isLogin) {
        await _authSvc.signIn(email.text.trim(), pass.text.trim());
      } else {
        await _authSvc.register(email.text.trim(), pass.text.trim());
      }
    } catch (e) {
      msg(e.toString());
    }
  }

  Future<void> _google() async {
    try {
      await AuthService.signInWithGoogle();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: ${e.toString()}'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _facebook() async {
    try {
      await AuthService.signInWithFacebook();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Facebook Sign-In failed: ${e.toString()}'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: email, decoration: const InputDecoration(labelText:'Email')),
            TextField(controller: pass, obscureText:true, decoration: const InputDecoration(labelText:'Password')),
            const SizedBox(height:20),
            ElevatedButton(onPressed:_submit, child: Text(isLogin?'Login':'Register')),
            TextButton(
                onPressed: ()=>setState(()=>isLogin=!isLogin),
                child: Text(isLogin?'Create account':'Already have one?')
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _google,
                    icon: const Icon(Icons.login),
                    label: const Text('Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _facebook,
                    icon: const Icon(Icons.facebook),
                    label: const Text('Facebook'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
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
}