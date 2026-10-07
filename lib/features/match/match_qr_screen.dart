import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../models/match_model.dart';

class MatchQrScreen extends StatefulWidget {
  final MatchModel match;
  final String otherName;

  const MatchQrScreen({
    super.key,
    required this.match,
    this.otherName = '',
  });

  @override
  State<MatchQrScreen> createState() => _MatchQrScreenState();
}

class _MatchQrScreenState extends State<MatchQrScreen> {
  bool _saving = false;

  Future<void> _downloadPdf() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final payload = widget.match.qrPayload;
      final font = await PdfGoogleFonts.cairoRegular();
      final bold = await PdfGoogleFonts.cairoBold();
      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'CabaDZ',
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 28,
                  color: PdfColor.fromInt(0xFF0C3D2A),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Delivery QR',
                style: pw.TextStyle(font: font, fontSize: 16),
              ),
              pw.SizedBox(height: 28),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: payload,
                width: 260,
                height: 260,
              ),
              pw.SizedBox(height: 24),
              if (widget.match.deliveryCode != null &&
                  widget.match.deliveryCode!.isNotEmpty)
                pw.Text(
                  'Code: ${widget.match.deliveryCode}',
                  style: pw.TextStyle(font: bold, fontSize: 18),
                ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Match ${widget.match.id}',
                style: pw.TextStyle(font: font, fontSize: 10),
              ),
              pw.SizedBox(height: 24),
              pw.Text(
                'Show this QR to the traveler to complete delivery.',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
            ],
          ),
        ),
      );
      await Printing.sharePdf(
        bytes: await doc.save(),
        filename: 'caba-delivery-${widget.match.deliveryCode ?? widget.match.id}.pdf',
      );
    } catch (_) {
      if (mounted) showCabaErrorSnack(context, AppStrings.pdfFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(titleText: AppStrings.matchQrTitle),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: [
              Text(
                AppStrings.matchQrHint,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: match.qrPayload,
                  size: 240,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppColors.primary,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (match.deliveryCode != null &&
                  match.deliveryCode!.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(AppStrings.deliveryCodeLabel, style: AppTextStyles.bodySmall),
                Text(
                  match.deliveryCode!,
                  style: AppTextStyles.headlineLarge.copyWith(
                    letterSpacing: 3,
                    color: AppColors.primary,
                  ),
                ),
              ],
              const Spacer(),
              CabaButton(
                label: AppStrings.downloadQrPdf,
                icon: Icons.picture_as_pdf_rounded,
                isLoading: _saving,
                onTap: _downloadPdf,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
