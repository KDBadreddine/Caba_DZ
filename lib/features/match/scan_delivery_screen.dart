import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../models/match_model.dart';

class ScanDeliveryScreen extends StatefulWidget {
  final MatchModel match;

  const ScanDeliveryScreen({super.key, required this.match});

  @override
  State<ScanDeliveryScreen> createState() => _ScanDeliveryScreenState();
}

class _ScanDeliveryScreenState extends State<ScanDeliveryScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _handled = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) return;
    final raw = capture.barcodes
        .map((b) => b.rawValue)
        .whereType<String>()
        .firstWhere((v) => v.trim().isNotEmpty, orElse: () => '');
    if (raw.isEmpty) return;
    _handled = true;
    await _controller.stop();

    final result = await completeDeliveryByQr(
      raw,
      expectedMatchId: widget.match.id,
    );
    if (!mounted) return;

    switch (result) {
      case DeliveryScanResult.success:
        await showCabaSuccessDialog(
          context,
          title: AppStrings.deliverySuccessTitle,
          subtitle: AppStrings.deliverySuccessSub,
        );
        if (mounted) Navigator.pop(context, true);
      case DeliveryScanResult.alreadyDone:
        await showCabaSuccessDialog(
          context,
          title: AppStrings.alreadyDelivered,
        );
        if (mounted) Navigator.pop(context, true);
      case DeliveryScanResult.invalid:
        _fail(AppStrings.invalidQr);
      case DeliveryScanResult.notTraveler:
        _fail(AppStrings.scanNotTraveler);
      case DeliveryScanResult.notReady:
        _fail(AppStrings.matchNotReady);
    }
  }

  Future<void> _fail(String message) async {
    if (!mounted) return;
    showCabaErrorSnack(context, message);
    _handled = false;
    await _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CabaAppBar(titleText: AppStrings.scanTitle),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Text(
              AppStrings.scanHint,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
