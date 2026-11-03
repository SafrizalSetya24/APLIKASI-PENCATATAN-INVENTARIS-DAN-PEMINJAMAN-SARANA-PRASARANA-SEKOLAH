import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/inventory_item.dart';
import '../../data/mock_data.dart';

class BarcodeScannerModal extends StatefulWidget {
  final Function(InventoryItem item) onItemScanned;

  const BarcodeScannerModal({super.key, required this.onItemScanned});

  @override
  State<BarcodeScannerModal> createState() => _BarcodeScannerModalState();
}

class _BarcodeScannerModalState extends State<BarcodeScannerModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _laserAnim;
  final TextEditingController _manualController = TextEditingController();
  InventoryItem? _detectedItem;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnim = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _handleSelectBarcode(String barcode) {
    final item = MockData.items.firstWhere(
      (element) => element.barcode == barcode || element.id == barcode,
      orElse: () => MockData.items.first,
    );

    setState(() {
      _isProcessing = true;
      _detectedItem = item;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onItemScanned(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final double boxSize = isMobile ? 180.0 : 240.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24, vertical: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 560, maxHeight: isMobile ? 620 : 700),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMobile ? 'Scan Barcode' : 'Scan Barcode Sarpras',
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            'SMK Muhammadiyah Kramat',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Kamera / Viewfinder frame
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Grid background pattern
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.15,
                          child: CustomPaint(
                            painter: _ScannerGridPainter(),
                          ),
                        ),
                      ),

                      // Scanning Frame Box
                      Container(
                        width: boxSize,
                        height: boxSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _detectedItem != null
                                ? AppColors.success
                                : AppColors.primary.withValues(alpha: 0.8),
                            width: 2.2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // 4 Corner brackets
                            const Align(
                              alignment: Alignment.topLeft,
                              child: _CornerMarker(top: true, left: true),
                            ),
                            const Align(
                              alignment: Alignment.topRight,
                              child: _CornerMarker(top: true, left: false),
                            ),
                            const Align(
                              alignment: Alignment.bottomLeft,
                              child: _CornerMarker(top: false, left: true),
                            ),
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: _CornerMarker(top: false, left: false),
                            ),

                            // Laser Beam
                            if (_detectedItem == null)
                              AnimatedBuilder(
                                animation: _laserAnim,
                                builder: (context, child) {
                                  return Positioned(
                                    top: boxSize * _laserAnim.value,
                                    left: 8,
                                    right: 8,
                                    child: Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.9),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.greenAccent,
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                            // Detected Success Overlay
                            if (_detectedItem != null)
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white, size: 32),
                                      const SizedBox(height: 4),
                                      Text(
                                        _detectedItem!.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        'Barcode: ${_detectedItem!.barcode}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Bottom status hint on camera
                      Positioned(
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Arahkan Barcode tepat di dalam kotak',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Simulation Barcode Selector
              const Text(
                'Simulasi Scan Cepat (Pilih Sampel Aset):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _QuickScanChip(
                    label: '🪑 Kursi Lipat (8991001001)',
                    onTap: () => _handleSelectBarcode('8991001001'),
                  ),
                  _QuickScanChip(
                    label: '📽️ Proyektor (8991001002)',
                    onTap: () => _handleSelectBarcode('8991001002'),
                  ),
                  _QuickScanChip(
                    label: '🔊 Sound System (8991001003)',
                    onTap: () => _handleSelectBarcode('8991001003'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Manual Input Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _manualController,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Ketik Barcode manual...',
                        prefixIcon: Icon(Icons.keyboard_outlined, size: 18),
                      ),
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          _handleSelectBarcode(val.trim());
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            if (_manualController.text.trim().isNotEmpty) {
                              _handleSelectBarcode(_manualController.text.trim());
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    child: const Text('Cari'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickScanChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickScanChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  final bool top;
  final bool left;

  const _CornerMarker({required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: Colors.greenAccent, width: 2.5) : BorderSide.none,
          bottom: !top ? const BorderSide(color: Colors.greenAccent, width: 2.5) : BorderSide.none,
          left: left ? const BorderSide(color: Colors.greenAccent, width: 2.5) : BorderSide.none,
          right: !left ? const BorderSide(color: Colors.greenAccent, width: 2.5) : BorderSide.none,
        ),
      ),
    );
  }
}

class _ScannerGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    const double step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
