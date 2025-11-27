import 'package:flutter/material.dart';
import 'package:proyecto/features/auth/data/profile_service.dart';
import 'package:proyecto/features/auth/data/user_profile_model.dart';
import 'package:proyecto/core/utils/theme_service.dart'; // Asegúrate de importar esto

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos ValueListenableBuilder para escuchar los cambios de tema en tiempo real
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.instance.isDarkMode,
      builder: (context, isDarkMode, _) {
        
        // Definimos colores dinámicos basados en el tema
        final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
        final cardColor = Theme.of(context).cardColor;
        final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

        return Scaffold(
          backgroundColor: backgroundColor,
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
                              colors: [Colors.deepPurple, Color.fromARGB(255, 65, 34, 119)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(0),
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
                                  backgroundImage: (displayPhoto != null && displayPhoto.isNotEmpty)
                                      ? NetworkImage(displayPhoto)
                                      : const NetworkImage('https://i.pravatar.cc/300'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                displayEmail,
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
                          color: cardColor, // Color dinámico
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
                            // SWITCH PERSONALIZADO ANIMADO
                            _buildCustomAnimatedSwitch(
                              icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                              title: "Modo Oscuro",
                              value: isDarkMode,
                              onChanged: (val) {
                                ThemeService.instance.toggleTheme(val);
                              },
                              textColor: textColor,
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
    );
  }

  // ⭐ Nuevo Widget para el Switch Animado "Bacano"
  Widget _buildCustomAnimatedSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required Color textColor,
  }) {
    return ListTile(
      // Mismo estilo de leading que las otras opciones
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      // Aquí está la magia de la animación
      trailing: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 55,
          height: 30,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            // Fondo cambia: Morado oscuro si activo, gris claro si inactivo
            color: value ? const Color(0xFF311B92) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: value ? Colors.deepPurple.shade400 : Colors.grey.shade400,
              width: 1
            )
          ),
          child: Stack(
            children: [
              // El círculo que se mueve (Sol / Luna)
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut, // Efecto rebote suave
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  // Icono dentro del switch que rota o cambia
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => RotationTransition(turns: anim, child: child),
                    child: Icon(
                      value ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                      key: ValueKey<bool>(value),
                      size: 16,
                      color: value ? Colors.deepPurple : Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para opciones normales (ligeramente ajustado para aceptar color de texto)
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
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text("Salir", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}