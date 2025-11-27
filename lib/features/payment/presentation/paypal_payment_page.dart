import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/paypal_repository.dart';

class PaypalPaymentPage extends StatefulWidget {
  final String approvalUrl;
  final Function(String orderId) onPaymentSuccess;
  final VoidCallback onPaymentCancel;

  const PaypalPaymentPage({
    super.key,
    required this.approvalUrl,
    required this.onPaymentSuccess,
    required this.onPaymentCancel,
  });

  @override
  State<PaypalPaymentPage> createState() => _PaypalPaymentPageState();
}

class _PaypalPaymentPageState extends State<PaypalPaymentPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {

            if (request.url.contains('/api/paypal/success')) {
              final uri = Uri.parse(request.url);
              final orderId = uri.queryParameters['token']; 
              
              if (orderId != null) {
                widget.onPaymentSuccess(orderId);
              }
              return NavigationDecision.prevent;
            }
            
            // 🔍 DETECTAR CANCELACIÓN
            if (request.url.contains('/api/paypal/cancel')) {
              widget.onPaymentCancel();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagar con PayPal"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}