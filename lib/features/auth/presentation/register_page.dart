import 'package:flutter/material.dart';
import 'package:proyecto/core/widgets/custom_input.dart';
import 'package:proyecto/features/auth/data/auth_repository_impl.dart';
import 'package:proyecto/features/auth/domain/usuario.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();

  final repo = AuthRepositoryImpl();
  bool _isLoading = false; // Para mostrar un spinner mientras carga

  void _register() async {
    // 1. Validaciones básicas
    if (nombreController.text.isEmpty ||
        apellidoController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor completa todos los campos obligatorios"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Activar carga
    });

    try {
      final user = Usuario(
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        email: emailController.text.trim(),
        telefono: telefonoController.text.trim(),
        password: passwordController.text,
      );

      // 2. Llamada al Backend
      final success = await repo.register(user);

      if (success && mounted) {
        // 3. Éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ ¡Cuenta creada con éxito! Inicia sesión."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Volver al Login
      }
    } catch (e) {
      // 4. Manejo de Errores (Ej: Email duplicado)
      if (mounted) {
        // Limpiamos el mensaje de error para que sea legible (quitamos "Exception:")
        final errorMessage = e.toString().replaceAll("Exception: ", "");
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $errorMessage"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Desactivar carga
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Crear cuenta"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Icon(Icons.person_add_alt_1,
                  size: 80, color: Colors.deepPurple.shade400),
              const SizedBox(height: 15),
              Text(
                "Regístrate",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Completa tus datos para crear tu cuenta",
                style: TextStyle(fontSize: 15, color: Colors.deepPurple.shade300),
              ),
              const SizedBox(height: 35),

              // CAMPOS DE TEXTO
              CustomInput(
                controller: nombreController,
                label: "Nombre",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: apellidoController,
                label: "Apellido",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: emailController,
                label: "Email",
                keyboard: TextInputType.emailAddress,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: telefonoController,
                label: "Teléfono",
                keyboard: TextInputType.phone,
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: passwordController,
                label: "Password",
                isPassword: true,
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 25),

              // BOTÓN DE REGISTRO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _isLoading ? null : _register, // Deshabilita si carga
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Registrarse",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "¿Ya tienes cuenta? Inicia sesión",
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
