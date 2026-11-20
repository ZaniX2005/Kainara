import 'dart:typed_data';
import 'package:flutter/material.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamera/galeri tidak bisa dibuka di perangkat ini')),
      );
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
        title: Text('Cara memindai',
            style: AppText.serif(20, color: AppColors.maroon)),
        content: Text(
          _mode == 0
              ? 'Arahkan kamera ke kain tapis hingga motif memenuhi bingkai, lalu tekan tombol pindai.'
              : 'Arahkan kamera ke wajah di tempat yang terang, lalu tekan tombol pindai untuk mengetahui warna kulitmu.',
          style: AppText.sans(12, color: AppColors.dark, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup',
                style: AppText.serif(16, color: AppColors.maroon)),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Color(0x26000000), blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.maroon),
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
            BoxShadow(color: Color(0x40000000), blurRadius: 14, offset: Offset(0, 5)),
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
            child: const Icon(Icons.center_focus_strong_outlined,
                color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _viewport() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Color(0x44000000), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _bytes == null
                  ? const AssetImg('assets/images/scan_sample.png')
                  : Image.memory(_bytes!, fit: BoxFit.cover),
              if (_analyzing)
                const ColoredBox(color: Color(0x73000000)),
              Positioned.fill(
                child: CustomPaint(painter: _CornerPainter()),
              ),
              if (_analyzing)
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.maroon : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              label,
              style: AppText.serif(
                16,
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
    return Scaffold(
      backgroundColor: AppColors.page,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.0,
            colors: [Color(0xFFFFF8EE), Color(0xFFF4EADB)],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(18, mq.padding.top + 12, 18, 16),
              decoration: const BoxDecoration(
                color: AppColors.maroon,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: AppColors.page, shape: BoxShape.circle),
                      child: const Icon(Icons.chevron_left,
                          color: AppColors.maroon, size: 28),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'PEMINDAI  MOTIF TAPIS',
                      textAlign: TextAlign.center,
                      style: AppText.serif(14, color: AppColors.cream),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showHelp,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: AppColors.page, shape: BoxShape.circle),
                      child: Center(
                        child: Text('?',
                            style: AppText.serif(20, color: AppColors.maroon)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(36, 34, 36, 40),
                child: Column(
                  children: [
                    _viewport(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _smallButton(Icons.photo_library_outlined,
                            () => _pick(ImageSource.gallery)),
                        _shutter(),
                        _smallButton(Icons.flip_camera_android_outlined, () {
                          setState(() => _cam = _cam == CameraDevice.rear
                              ? CameraDevice.front
                              : CameraDevice.rear);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            content: Text(_cam == CameraDevice.rear
                                ? 'Kamera belakang'
                                : 'Kamera depan'),
                          ));
                        }),
                      ],
                    ),
                    const SizedBox(height: 70),
                    _modeToggle(),
                  ],
                ),
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