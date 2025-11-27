import 'package:flutter/material.dart';
import 'package:proyecto/features/categorias/presentation/categorias_page.dart';
import 'package:proyecto/features/productos/presentation/inicio.dart';
import 'package:proyecto/features/auth/presentation/profile_page.dart';

class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    InicioPage(),
    CategoriasPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: IndexedStack(
        index: _currentIndex,
         children: _pages),

      // ⭐ BARRA DE NAVEGACIÓN INFERIOR BONITA
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(24, 23, 23, 0.247),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                backgroundColor: Colors.white,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepPurple,
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

class _PrimeraSeccionPage extends StatelessWidget {
  const _PrimeraSeccionPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Sección principal\n(Aquí tú vas a ir agregando cosas)",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class _SegundaSeccionPage extends StatelessWidget {
  const _SegundaSeccionPage();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Sección 2"));
  }
}

class _TerceraSeccionPage extends StatelessWidget {
  const _TerceraSeccionPage();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Perfil / Sección 3"));
  }
}
