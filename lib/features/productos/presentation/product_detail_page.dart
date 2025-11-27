import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/features/productos/data/product_model.dart';
import 'package:proyecto/features/carrito/data/carrito_service.dart';
import 'package:proyecto/features/carrito/presentation/carrito_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _showGoToCart = false; 
  void _incrementQuantity() {
    if (_quantity < widget.product.stock) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[300] : Colors.grey[700];
    final primaryPurple = Colors.deepPurple;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 20),
            color: textColor,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),

      body: Stack(
        children: [
          // 1. CONTENIDO SCROLLEABLE
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 IMAGEN
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 110, 20, 40),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                    gradient: isDarkMode 
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.deepPurple.shade900, backgroundColor],
                          )
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.white],
                          ),
                  ),
                  child: Hero(
                    tag: widget.product.imagenUrl,
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imagenUrl,
                      height: 280,
                      fit: BoxFit.contain,
                      errorWidget: (_,__,___) => Icon(Icons.image_not_supported, size: 50, color: subTextColor),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 📝 INFO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.nombre,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor, height: 1.2),
                      ),
                      const SizedBox(height: 15),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "S/. ${widget.product.precio.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w900,
                              color: isDarkMode ? Colors.deepPurpleAccent.shade100 : primaryPurple,
                            ),
                          ),
                          // Chip de stock...
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: widget.product.stock > 0 
                                  ? (isDarkMode ? Colors.green.withOpacity(0.2) : Colors.green.shade50)
                                  : (isDarkMode ? Colors.red.withOpacity(0.2) : Colors.red.shade50),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.product.stock > 0 ? "Stock: ${widget.product.stock}" : "Agotado",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: widget.product.stock > 0 
                                    ? (isDarkMode ? Colors.greenAccent : Colors.green.shade700)
                                    : (isDarkMode ? Colors.redAccent : Colors.red.shade700),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                      // Descripción y Detalles...
                      if (widget.product.descripcion != null) ...[
                        Text("Descripción", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Text(widget.product.descripcion!, style: TextStyle(fontSize: 16, height: 1.5, color: subTextColor)),
                      ],
                      

                      SizedBox(height: _showGoToCart ? 220 : 160), 
                    ],
                  ),
                ),
              ],
            ),
          ),


          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withOpacity(0.0),
                    backgroundColor.withOpacity(0.95),
                    backgroundColor,
                  ],
                  stops: const [0.0, 0.2, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onTap: _decrementQuantity,
                        isEnabled: _quantity > 1,
                        isDarkMode: isDarkMode,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "$_quantity",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onTap: _incrementQuantity,
                        isEnabled: _quantity < widget.product.stock,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple, 
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(55),
                      elevation: 8,
                      shadowColor: primaryPurple.withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: widget.product.stock > 0 ? () {

                      for (int i = 0; i < _quantity; i++) {
                        CarritoService.instance.addToCart(widget.product);
                      }
                      

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$_quantity x ${widget.product.nombre} agregado"),
                          backgroundColor: Colors.green,
                          duration: const Duration(milliseconds: 1500),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );


                      setState(() {
                        _showGoToCart = true;
                        _quantity = 1;
                      });
                    } : null,
                    child: Text(
widget.product.stock > 0 
                          ? "Agregar al Carrito - S/. ${(widget.product.precio * _quantity).toStringAsFixed(2)}" // 👈 CAMBIO AQUÍ
                          : "Sin Stock",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _showGoToCart ? Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryPurple, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          backgroundColor: isDarkMode ? Colors.deepPurple.withOpacity(0.1) : Colors.white,
                        ),
                        onPressed: () {
                          // Navegar al carrito
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CarritoPage()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ir al Carrito",
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : primaryPurple
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: isDarkMode ? Colors.white : primaryPurple)
                          ],
                        ),
                      ),
                    ) : const SizedBox.shrink(), // Oculto si es false
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon, 
    required VoidCallback onTap, 
    required bool isEnabled,
    required bool isDarkMode
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode 
            ? (isEnabled ? Colors.deepPurple.withOpacity(0.3) : Colors.grey.withOpacity(0.1))
            : (isEnabled ? Colors.deepPurple.shade50 : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEnabled ? Colors.deepPurple.withOpacity(0.5) : Colors.transparent
        ),
      ),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon, 
            color: isEnabled 
                ? (isDarkMode ? Colors.white : Colors.deepPurple) 
                : Colors.grey,
            size: 26,
          ),
        ),
      ),
    );
  }
}