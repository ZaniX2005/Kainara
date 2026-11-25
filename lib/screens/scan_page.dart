import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/asset_img.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _picker = ImagePicker();
  Uint8List? _bytes;
  bool _analyzing = false;
  int _mode = 0; // 0 = scan motif, 1 = scan skintone
  CameraDevice _cam = CameraDevice.rear;

  Future<void> _showInvalidScanDialog() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.page,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gambar yang Anda masukkan tidak valid. Silahkan untuk melakukan Scan ulang.',
                textAlign: TextAlign.center,
                style: AppText.serif(
                  14,
                  color: AppColors.maroon,
                  weight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.go('/');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.dark,
                        side: const BorderSide(color: Color(0xFFD2CEC7)),
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kembali ke home',
                        textAlign: TextAlign.center,
                        style: AppText.serif(
                          13,
                          color: AppColors.dark,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        setState(() {
                          _bytes = null;
                          _analyzing = false;
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Coba lagi',
                        style: AppText.serif(
                          14,
                          color: Colors.white,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    if (_analyzing) return;
    try {
      final file = await _picker.pickImage(
        source: source,
        preferredCameraDevice: _cam,
        maxWidth: 1600,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _bytes = bytes;
        _analyzing = true;
      });
      await _analyze();
    } catch (_) {
      if (!mounted) return;
      await _showInvalidScanDialog();
    }
  }

  // Sementara hanya simulasi. Ganti dengan model/API pengenalan motif.
  Future<void> _analyze() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _analyzing = false);
    if (_mode == 0) {
      context.push('/scan-result/${motifs.first.id}?acc=98');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Analisis skintone selesai (contoh)')),
      );
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.page,
        title: Text(
          'Cara memindai',
          style: AppText.serif(20, color: AppColors.maroon),
        ),
        content: Text(
          _mode == 0
              ? 'Arahkan kamera ke kain tapis hingga motif memenuhi bingkai, lalu tekan tombol pindai.'
              : 'Arahkan kamera ke wajah di tempat yang terang, lalu tekan tombol pindai untuk mengetahui warna kulitmu.',
          style: AppText.sans(12, color: AppColors.dark, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: AppText.serif(16, color: AppColors.maroon),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: AppColors.maroon),
        ),
      ),
    );
  }

  Widget _shutter() {
    return GestureDetector(
      onTap: () => _pick(ImageSource.camera),
      child: Container(
        width: 76,
        height: 76,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.maroon,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: const Icon(
              Icons.center_focus_strong_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewport() {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000)
                .withValues(alpha: _analyzing ? 0.28 : 0.08),
            blurRadius: _analyzing ? 18 : 6,
            offset: Offset(0, _analyzing ? 10 : 2),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _bytes == null
                  ? AssetImg(motifs[3].image)
                  : Image.memory(_bytes!, fit: BoxFit.cover),
              if (_analyzing) const ColoredBox(color: Color(0x73000000)),
              Positioned.fill(child: CustomPaint(painter: _CornerPainter())),
              if (_analyzing)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xCC6B0D0D),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      _mode == 0 ? 'ANALISIS MOTIF...' : 'ANALISIS SKINTONE...',
                      style: AppText.serif(15, weight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeToggle() {
    Widget seg(int i, String label) {
      final active = _mode == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _mode = i),
          child: Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.maroon : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              label,
              style: AppText.serif(
                14,
                color: active ? Colors.white : const Color(0xFF9A8F84),
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFE6DDCF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [seg(0, 'scan motif'), seg(1, 'scan skintone')]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.page,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, mq.padding.top + 12, 20, 10),
              decoration: const BoxDecoration(
                color: AppColors.page,
                border: Border(bottom: BorderSide(color: Color(0xFFF1E8DE))),
              ),
              child: Row(
                children: [
                  Material(
                    color: AppColors.maroon,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () =>
                          context.canPop() ? context.pop() : context.go('/'),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'PEMINDAI MOTIF TAPIS',
                      style: AppText.serif(
                        14,
                        color: AppColors.maroon,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _showHelp,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            '?',
                            style: AppText.serif(20, color: AppColors.maroon),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxHeight;
                  final frameSize = math.min(
                    constraints.maxWidth - 64,
                    height * 0.445,
                  );
                  final topSpacing = (height * 0.115).clamp(32.0, 88.0);
                  final controlSpacing = (height * 0.05).clamp(16.0, 36.0);
                  final modeSpacing = (height * 0.12).clamp(36.0, 88.0);
                  final bottomSpacing = (height * 0.10).clamp(28.0, 74.0);
                  final controlsWidth = math.min(
                    constraints.maxWidth * 0.63,
                    250.0,
                  );

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: mq.padding.bottom),
                    child: Column(
                      children: [
                        SizedBox(height: topSpacing),
                        SizedBox(
                          width: frameSize,
                          height: frameSize,
                          child: _viewport(),
                        ),
                        SizedBox(height: controlSpacing),
                        SizedBox(
                          width: controlsWidth,
                          height: 76,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _smallButton(
                                Icons.photo_library_outlined,
                                () => _pick(ImageSource.gallery),
                              ),
                              _shutter(),
                              _smallButton(
                                Icons.flip_camera_android_outlined,
                                () {
                                  setState(
                                    () => _cam = _cam == CameraDevice.rear
                                        ? CameraDevice.front
                                        : CameraDevice.rear,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: Text(
                                        _cam == CameraDevice.rear
                                            ? 'Kamera belakang'
                                            : 'Kamera depan',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: modeSpacing),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _modeToggle(),
                        ),
                        SizedBox(height: bottomSpacing),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empat sudut putih pada bingkai pindai.
class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square;
    const m = 12.0, l = 28.0;
    final w = size.width, h = size.height;

    void corner(double x, double y, double dx, double dy) {
      canvas.drawLine(Offset(x, y), Offset(x + dx * l, y), p);
      canvas.drawLine(Offset(x, y), Offset(x, y + dy * l), p);
    }

    corner(m, m, 1, 1);
    corner(w - m, m, -1, 1);
    corner(m, h - m, 1, -1);
    corner(w - m, h - m, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) => false;
}
