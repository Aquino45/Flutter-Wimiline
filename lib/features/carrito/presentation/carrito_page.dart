import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/features/carrito/data/carrito_service.dart';
import 'package:proyecto/features/carrito/domain/carrito_item.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  // Estados para la selección de fecha y hora
  DateTime? _selectedDate;
  String _selectedTimeSlot = "11 AM - 12 PM"; // Valor por defecto o null
  
  // Opciones de horarios (hardcoded por ahora, podrían venir del backend)
  final List<String> _timeSlots = [
    "8 AM - 11 AM",
    "11 AM - 12 PM",
    "12 PM - 2 PM",
    "2 PM - 4 PM",
    "4 PM - 6 PM",
    "6 PM - 8 PM",
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    
    // Colores basados en tu imagen (Tonos lilas/morados)
    final primaryPurple = Colors.deepPurple;
    final lightPurpleBg = isDarkMode ? Colors.deepPurple.withOpacity(0.1) : Colors.deepPurple.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Mi Bolsa", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Eliminamos el botón de atrás si es una página principal del BottomNav
        automaticallyImplyLeading: false, 
      ),
      body: ValueListenableBuilder<List<CarritoItem>>(
        valueListenable: CarritoService.instance.itemsNotifier,
        builder: (context, items, _) {
          
          if (items.isEmpty) {
            return _buildEmptyState(context, isDarkMode);
          }

          // Cálculos
          final subtotal = CarritoService.instance.totalAmount;
          final deliveryFee = 5.00; // Costo fijo por ahora
          final total = subtotal + deliveryFee;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. LISTA DE PRODUCTOS
                const Text("Productos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) => _buildProductRow(items[index], isDarkMode, cardColor),
                ),

                const SizedBox(height: 20),

                // Botón "Añadir más productos" (Visual)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: lightPurpleBg,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Aquí podrías navegar al Home o Categorías
                      // Navigator.pushNamed(context, '/main'); // O cambiar tab
                    },
                    child: Text("Añadir más productos", 
                      style: TextStyle(color: primaryPurple, fontWeight: FontWeight.w600)
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 2. PROGRAMAR ENTREGA (Fecha y Hora)
                const Text("Programar fecha y horario de entrega", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 15),
                
                // Selector de Fecha
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 7)),
                    );
                    if (date != null) setState(() => _selectedDate = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 10),
                        Text(
                          _selectedDate == null 
                              ? "Selecciona una fecha" 
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Grid de Horarios
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _timeSlots.map((slot) {
                    final isSelected = _selectedTimeSlot == slot;
                    return InkWell(
                      onTap: () => setState(() => _selectedTimeSlot = slot),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.transparent : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
                          border: isSelected ? Border.all(color: primaryPurple, width: 1.5) : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? primaryPurple : (isDarkMode ? Colors.white70 : Colors.black54),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                // 3. UBICACIÓN (Estática por ahora)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ubicación de Delivery", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: (){}, child: const Text("Cambiar")),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                      child: const Icon(Icons.location_on_outlined, color: Colors.black54),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Casa", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Av. Siempre Viva 123, Springfield", 
                            style: TextStyle(color: Colors.grey, fontSize: 13), 
                            maxLines: 1, overflow: TextOverflow.ellipsis
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 4. RESUMEN DE COSTOS
                _buildCostRow("Subtotal", "PEN ${subtotal.toStringAsFixed(2)}"),
                const SizedBox(height: 10),
                _buildCostRow("Cargo del Delivery", "PEN ${deliveryFee.toStringAsFixed(2)}"),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(),
                ),
                _buildCostRow("Total", "PEN ${total.toStringAsFixed(2)}", isTotal: true),

                const SizedBox(height: 30),

                // 5. MÉTODO DE PAGO
                const Text("Método de Pago", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: lightPurpleBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.credit_card, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tarjeta de Crédito/Débito", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text("Termina en **** 1234", style: TextStyle(color: primaryPurple, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 6. BOTÓN FINAL DE PEDIDO
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      _procesarPedido(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hacer Pedido", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
                
                // Espacio extra para que no choque con el navigation bar
                const SizedBox(height: 50),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildProductRow(CarritoItem item, bool isDarkMode, Color cardColor) {
    return Row(
      children: [
        // Imagen pequeña
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: CachedNetworkImage(
            imageUrl: item.product.imagenUrl,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 15),
        
        // Texto
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.nombre, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2, overflow: TextOverflow.ellipsis
              ),
              const SizedBox(height: 4),
              // Aquí podrías poner "1kg" o "Unidad" si lo tuvieras en el modelo
              Text("s/ ${item.product.precio}", 
                style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[400], fontSize: 12)
              ),
              Text("S/. ${item.product.precio}", 
                style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.deepPurple, fontSize: 16)
              ),
            ],
          ),
        ),

        // Controles +/-
        Row(
          children: [
            _buildIconButton(Icons.remove, () => CarritoService.instance.removeOrDecrement(item.product)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            _buildIconButton(Icons.add, () => CarritoService.instance.addToCart(item.product)),
          ],
        )
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1), // Lila muy suave
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, 
          style: TextStyle(
            fontSize: isTotal ? 18 : 14, 
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? null : Colors.grey[600]
          )
        ),
        Text(value, 
          style: TextStyle(
            fontSize: isTotal ? 18 : 14, 
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold
          )
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text("Tu bolsa está vacía", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white70 : Colors.grey)
          ),
        ],
      ),
    );
  }


  void _procesarPedido(BuildContext context) async {


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await CarritoService.instance.realizarPedido();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Pedido realizado con éxito! 🚀"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }
}