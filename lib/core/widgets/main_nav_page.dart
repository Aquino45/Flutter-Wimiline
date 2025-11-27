import 'package:flutter/material.dart';
import 'package:proyecto/features/categorias/presentation/categorias_page.dart';
import 'package:proyecto/features/productos/presentation/inicio.dart';
import 'package:proyecto/features/auth/presentation/profile_page.dart';
// 👇 Importamos la nueva página
import 'package:proyecto/features/carrito/presentation/carrito_page.dart'; 

class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;

  // Agregamos CarritoPage a la lista
  final List<Widget> _pages = const [
    InicioPage(),
    CategoriasPage(),
    CarritoPage(), // 👈 Nueva pantalla en el índice 2
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: IndexedStack(
        index: _currentIndex,
         children: _pages
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, 
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                backgroundColor: Colors.transparent, 
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                
                selectedItemColor: isDarkMode ? Colors.white : Colors.deepPurple,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: false,
                selectedFontSize: 12,
                unselectedFontSize: 11,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: "Inicio",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt_outlined),
                    activeIcon: Icon(Icons.list_alt),
                    label: "Categorias",
                  ),
                  // 👇 Nuevo botón de Carrito
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_outlined),
                    activeIcon: Icon(Icons.shopping_cart),
                    label: "Carrito",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: "Perfil",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}