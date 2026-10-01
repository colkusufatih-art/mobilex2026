import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class QrBillPdfData {
  final String recipientAccount;
  final String recipientAddress;
  final String currency;
  final String amount;
  final String additionalInformation;
  final String payerName;
  final String payerAddress;
  final String payerPostCode;
  final String payerCity;
  final String payerCountry;

  QrBillPdfData({
    required this.recipientAccount,
    required this.recipientAddress,
    required this.currency,
    required this.amount,
    required this.additionalInformation,
    required this.payerName,
    required this.payerAddress,
    required this.payerPostCode,
    required this.payerCity,
    required this.payerCountry,
  });
}

class QrBillPdfService {
  QrBillPdfService._();

  static const String _qrImagePath = 'assets/img/QR Code.png';
  static const String _cutIconPath = 'assets/img/content_cut.png';
  static const double _pageWidthMm = 210;
  static const double _pageHeightMm = 297;
  static const double _receiptWidthMm = 62;
  static const double _paymentPartWidthMm = 148;
  static const double _qrCodeSizeMm = 46;
  static const double _sectionPaddingMm = 5;

  static Future<Uint8List> generatePdf(QrBillPdfData data) async {
    final doc = pw.Document();

    final qrImageData = await rootBundle.load(_qrImagePath);
    final qrImage = pw.MemoryImage(qrImageData.buffer.asUint8List());
    final cutIconData = await rootBundle.load(_cutIconPath);
    final cutIconImage = pw.MemoryImage(cutIconData.buffer.asUint8List());

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          const receiptWidth = _receiptWidthMm * PdfPageFormat.mm;
          const paymentWidth = _paymentPartWidthMm * PdfPageFormat.mm;
          const pageHeight = _pageHeightMm * PdfPageFormat.mm;
          const sectionPadding = _sectionPaddingMm * PdfPageFormat.mm;
          const perforationWidth = 10.0;

          return pw.Container(
            width: _pageWidthMm * PdfPageFormat.mm,
            height: _pageHeightMm * PdfPageFormat.mm,
            child: pw.Stack(
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: receiptWidth,
                      height: pageHeight,
                      padding: const pw.EdgeInsets.all(sectionPadding),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          left: pw.BorderSide(color: PdfColors.black, width: 0.5),
                          top: pw.BorderSide(color: PdfColors.black, width: 0.5),
                          bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
                        ),
                      ),
                      child: _buildReceiptSection(data),
                    ),
                    pw.Container(
                      width: paymentWidth,
                      height: pageHeight,
                      padding: const pw.EdgeInsets.all(sectionPadding),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          top: pw.BorderSide(color: PdfColors.black, width: 0.5),
                          right: pw.BorderSide(color: PdfColors.black, width: 0.5),
                          bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
                        ),
                      ),
                      child: _buildPaymentPart(data, qrImage),
                    ),
                  ],
                ),
                pw.Positioned(
                  left: receiptWidth - (perforationWidth / 2),
                  top: sectionPadding,
                  bottom: sectionPadding,
                  child: _buildVerticalPerforation(
                    pageHeight - (2 * sectionPadding),
                    cutIconImage,
                    perforationWidth,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }
  static pw.Widget _buildVerticalPerforation(
    double availableHeight,
    pw.MemoryImage cutIconImage,
    double width,
  ) {
    const dashHeight = 4.0;
    const dashSpace = 2.0;
    const iconSize = 8 * PdfPageFormat.mm;
    const bottomSpacing = 8 * PdfPageFormat.mm;
    final dashAreaHeight =
        availableHeight - iconSize - bottomSpacing - (6 * PdfPageFormat.mm);
    final dashCount = dashAreaHeight <= 0
        ? 0
        : (dashAreaHeight / (dashHeight + dashSpace)).floor();

    return pw.Container(
      width: width,
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: List.generate(dashCount, (_) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: dashSpace),
                child: pw.Container(
                  width: 0.8,
                  height: dashHeight,
                  color: PdfColors.grey600,
                ),
              );
            }),
          ),
          pw.SizedBox(height: 6 * PdfPageFormat.mm),
          pw.Text(
            'Acceptance point',
            style: const pw.TextStyle(fontSize: 8),
          ),
          pw.SizedBox(height: 4),
          pw.Image(
            cutIconImage,
            width: iconSize,
            height: iconSize,
            fit: pw.BoxFit.contain,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildReceiptSection(QrBillPdfData data) {
    final payerLines = _composePayerLines(data);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Receipt',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 16),
        _buildLabelWithValues(
          'Account / Payable to',
          _splitLines('${data.recipientAccount}\n${data.recipientAddress}'),
        ),
        pw.SizedBox(height: 16),
        if (payerLines.isNotEmpty)
          _buildLabelWithValues('Payable by', payerLines),
        pw.SizedBox(height: 24),
        _buildCurrencyRow(data.currency, data.amount),
      ],
    );
  }

  static pw.Widget _buildPaymentPart(
    QrBillPdfData data,
    pw.MemoryImage qrImage,
  ) {
    final payerLines = _composePayerLines(data);
    const qrCodeSize = _qrCodeSizeMm * PdfPageFormat.mm;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Payment part',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: qrCodeSize,
              height: qrCodeSize,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(4 * PdfPageFormat.mm),
                child: pw.Image(qrImage, fit: pw.BoxFit.contain),
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildLabelWithValues(
                    'Account / Payable to',
                    _splitLines('${data.recipientAccount}\n${data.recipientAddress}'),
                  ),
                  pw.SizedBox(height: 12),
                  if (data.additionalInformation.isNotEmpty)
                    _buildLabelWithValues(
                      'Additional information',
                      _splitLines(data.additionalInformation),
                    ),
                  if (payerLines.isNotEmpty) ...[
                    pw.SizedBox(height: 12),
                    _buildLabelWithValues('Payable by', payerLines),
                  ],
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 24),
        _buildCurrencyRow(data.currency, data.amount),
      ],
    );
  }

  static pw.Widget _buildLabelWithValues(String label, List<String> values) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        ...values.map(
          (line) => pw.Text(
            line,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildCurrencyRow(String currency, String amount) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Currency',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                currency,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Amount',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                amount,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static List<String> _splitLines(String value) {
    return value.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  static List<String> _composePayerLines(QrBillPdfData data) {
    final lines = <String>[];
    if (data.payerName.isNotEmpty) {
      lines.add(data.payerName);
    }
    lines.addAll(_splitLines(data.payerAddress));

    final cityLine = [data.payerPostCode, data.payerCity]
        .where((value) => value.trim().isNotEmpty)
        .join(' ');
    if (cityLine.isNotEmpty) {
      lines.add(cityLine);
    }
    if (data.payerCountry.isNotEmpty) {
      lines.add(data.payerCountry);
    }
    return lines;
  }
}

