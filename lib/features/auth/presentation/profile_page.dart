import 'package:flutter/material.dart';
import 'package:proyecto/features/auth/data/profile_service.dart';
import 'package:proyecto/features/auth/data/user_profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false;
  
  // Variable para el futuro perfil
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    // Iniciamos la carga del perfil al arrancar la pantalla
    _profileFuture = ProfileService().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          String displayName = "Invitado";
          String displayEmail = "";
          String? displayPhoto;

          if (snapshot.hasData && snapshot.data != null) {
             displayName = snapshot.data!.fullName;
             displayEmail = snapshot.data!.email;
             displayPhoto = snapshot.data!.photoUrl;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // CABECERA CON DEGRADADO Y DATOS REALES
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 270,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Color(0xFF9575CD)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              // Si hay URL, úsala; si no, usa imagen por defecto
                              backgroundImage: (displayPhoto != null && displayPhoto.isNotEmpty)
                                  ? NetworkImage(displayPhoto)
                                  : const NetworkImage('https://i.pravatar.cc/300'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            displayName, // 👈 NOMBRE REAL
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            displayEmail, // 👈 EMAIL REAL
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // LISTA DE OPCIONES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSwitchOption(
                          icon: Icons.dark_mode_outlined,
                          title: "Modo Oscuro",
                          value: _isDarkMode,
                          onChanged: (val) {
                            setState(() => _isDarkMode = val);
                          },
                        ),
                        const Divider(height: 1),
                        _buildListOption(
                          icon: Icons.logout_rounded,
                          title: "Cerrar Sesión",
                          color: Colors.redAccent,
                          onTap: () => _showLogoutDialog(context),
                        ),

                                    const SizedBox(height: 30),
          
            const Text(
              "Versión 1.0.0",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget auxiliar para opciones normales
  Widget _buildListOption({
    required IconData icon,
    required String title,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Widget auxiliar para el Switch
  Widget _buildSwitchOption({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      activeColor: Colors.deepPurple,
      value: value,
      onChanged: onChanged,
    );
  }

  // Diálogo de confirmación para salir
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Cerrar sesión?"),
        content: const Text("¿Estás seguro de que quieres salir de la aplicación?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              // 1. Cerrar el diálogo
              Navigator.pop(ctx);
              // 2. Ir al Login y borrar historial de navegación
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text("Salir", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}