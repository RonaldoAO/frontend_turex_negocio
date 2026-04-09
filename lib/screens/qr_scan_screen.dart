import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _handled = false;
  final TextEditingController _codeController = TextEditingController();

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    if (capture.barcodes.isNotEmpty) {
      _handled = true;
      Navigator.of(context).pop(true);
    }
  }

  void _submitCode() {
    if (_handled) return;
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    _handled = true;
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Escanea un QR',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              color: Colors.black.withOpacity(0.6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.qr_code_scanner, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Escanea cualquier QR para completar la mision.',
                          style: GoogleFonts.manrope(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 4, 6, 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _codeController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submitCode(),
                            decoration: const InputDecoration(
                              hintText: 'Ingresa un codigo',
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E2430),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _submitCode,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF2E63F6),
                            textStyle: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
