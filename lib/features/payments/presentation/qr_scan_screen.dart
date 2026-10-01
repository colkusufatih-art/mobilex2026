import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:mobilex2025/core/theme/spacing.dart';
import '../domain/payment_draft.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  bool _isFlashOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleQrCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          _buildHeader(),
          _buildScanOverlay(),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeaderButton(
              icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
              onTap: () {
                setState(() {
                  _isFlashOn = !_isFlashOn;
                });
                _controller.toggleTorch();
              },
            ),
            Text(
              'Scan QR Code',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            _buildHeaderButton(
              icon: Icons.close,
              onTap: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black, size: 24),
        ),
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Center(
      child: SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 3),
                    left: BorderSide(color: Colors.white, width: 3),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 3),
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 3),
                    left: BorderSide(color: Colors.white, width: 3),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 3),
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Container(
            width: 343,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_upload, color: Color(0xFF333333), size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Upload file',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleQrCode(String rawValue) {
    _controller.stop();
    final draft = _parseQrCode(rawValue);
    context.push('/payments/qr-payment-step-1', extra: draft);
  }

  Future<void> _pickFile() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );

      if (file?.path != null) {
        final imageFile = File(file!.path!);

        // Read QR code from image file
        await _scanQrCodeFromFile(imageFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Auswählen der Datei: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _scanQrCodeFromFile(File imageFile) async {
    // Note: QR code scanning from image files requires additional setup
    // For now, we'll show a message that this feature is coming soon
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR-Code-Scan aus Datei wird in einer zukünftigen Version verfügbar sein. Bitte verwenden Sie die Kamera.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  PaymentDraft _parseQrCode(String qrData) {
    final lines = qrData.split('\n');
    
    if (lines.isEmpty || lines[0] != 'SPC') {
      return PaymentDraft();
    }

    final iban = lines.length > 3 ? lines[3] : '';
    final creditorName = lines.length > 5 ? lines[5] : '';
    final creditorStreet = lines.length > 6 ? lines[6] : '';
    final creditorHouseNumber = lines.length > 7 ? lines[7] : '';
    final creditorPostCode = lines.length > 8 ? lines[8] : '';
    final creditorCity = lines.length > 9 ? lines[9] : '';
    final creditorCountry = lines.length > 10 ? lines[10] : '';
    final reference = lines.length > 19 ? lines[19] : '';
    final additionalInfo = lines.length > 20 ? lines[20] : '';
    final amount = lines.length > 22 && lines[22].isNotEmpty ? lines[22] : '';
    final currency = lines.length > 23 && lines[23].isNotEmpty ? lines[23] : 'CHF';

    return PaymentDraft(
      iban: iban,
      recipientName: creditorName,
      addressLine1: creditorStreet,
      addressLine2: creditorHouseNumber,
      postCode: creditorPostCode,
      city: creditorCity,
      country: creditorCountry.isNotEmpty ? creditorCountry : 'Switzerland',
      recipientReference: reference,
      purposeOfPayment: additionalInfo,
      amount: amount,
      currency: currency,
    );
  }
}
