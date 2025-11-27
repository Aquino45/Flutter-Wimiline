import 'package:flutter/material.dart';
import 'package:proyecto/core/utils/token_service.dart';
import 'package:proyecto/core/widgets/custom_input.dart';
import 'package:proyecto/features/auth/data/login_repository_impl.dart';
import 'package:proyecto/features/auth/domain/usuario_login.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final email = TextEditingController();
  final password = TextEditingController();

  final repo = LoginRepositoryImpl();

 void _login(BuildContext context) async {
    try {
      final user = UsuarioLogin(
        email: email.text,
        password: password.text,
      );

    final token = await repo.login(user);

      if (token.isNotEmpty) {
        // ✅ CAMBIO: Usar TokenService en lugar de SharedPreferences
        await TokenService.saveToken(token); 

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/main');
          // ...
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/logo_B.png"),
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Inicia sesión para continuar",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.deepPurple.shade300,
                ),
              ),

              const SizedBox(height: 35),

              CustomInput(
                controller: email,
                label: "Email",
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
              ),

              const SizedBox(height: 15),

              CustomInput(
                controller: password,
                label: "Password",
                isPassword: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () => _login(context),
                  child: const Text(
                    "Ingresar",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, "/register"),
                child: Text(
                  "¿No tienes cuenta? Regístrate",
                  style: TextStyle(color: Colors.deepPurple.shade700, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
