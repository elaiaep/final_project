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
      await _authSvc.signInWithGoogle();
    } catch (e) {
      msg('Google Sign-In failed');
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
            ElevatedButton.icon(
              onPressed: _google,
              icon: const Icon(Icons.login),
              label: const Text('Google Sign‑In'),
            ),
          ],
        ),
      ),
    );
  }
}