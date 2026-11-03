import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/inventory_item.dart';
import '../../widgets/status_badge.dart';

class CatalogPage extends StatefulWidget {
  final List<InventoryItem> items;
  final Function(InventoryItem item) onBorrowItem;
  final VoidCallback onScanBarcode;
  final String searchQuery;

  const CatalogPage({
    super.key,
    required this.items,
    required this.onBorrowItem,
    required this.onScanBarcode,
    this.searchQuery = '',
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _selectedCategory = 'Semua';
  bool _onlyAvailable = false;

  final List<String> _categories = [
    'Semua',
    'Furniture & Mebel',
    'Elektronik & Multimedia',
    'Alat Praktik Kejuruan',
    'Perlengkapan Acara',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 640;

    // Filter items
    final filtered = widget.items.where((item) {
      final matchQuery = widget.searchQuery.isEmpty ||
          item.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          item.barcode.contains(widget.searchQuery) ||
          item.location.toLowerCase().contains(widget.searchQuery.toLowerCase());

      final matchCategory = _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchAvailable = !_onlyAvailable || item.availableStock > 0;

      return matchQuery && matchCategory && matchAvailable;
    }).toList();

    return Padding(
      padding: EdgeInsets.all(isMobile ? 14.0 : 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Ajakan & Header (Responsive layout)
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF007A48), Color(0xFF004D2E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Peminjaman Sarpras',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Katalog Ketersediaan Sarana & Prasarana',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Cek stok kursi aula, proyektor, hingga toolkit SMK Muhammadiyah Kramat secara real-time.',
                        style: TextStyle(fontSize: 11.5, color: Colors.white70),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: widget.onScanBarcode,
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          label: const Text('Scan Barcode Fisik'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Peminjaman Fasilitas Sekolah',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Katalog Ketersediaan Sarana & Prasarana',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Cek ketersediaan kursi, meja rapat, proyektor, hingga toolkit praktik SMK Muhammadiyah Kramat secara real-time.',
                              style: TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: widget.onScanBarcode,
                        icon: const Icon(Icons.qr_code_scanner, size: 20),
                        label: const Text('Scan Barcode Fisik'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 16),

          // Filters Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ..._categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedCategory = cat);
                      },
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Hanya yang Tersedia'),
                    selected: _onlyAvailable,
                    onSelected: (val) => setState(() => _onlyAvailable = val),
                    checkmarkColor: AppColors.primary,
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: _onlyAvailable ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: _onlyAvailable ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Item count status
          Text(
            'Menampilkan ${filtered.length} sarana prasarana sekolah',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 12),

          // Items Grid (Responsive count)
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 54, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'Fasilitas Tidak Ditemukan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Coba ubah kata kunci pencarian atau kategori filter.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 3;
                      if (constraints.maxWidth < 620) {
                        crossAxisCount = 1;
                      } else if (constraints.maxWidth < 980) {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 310,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _ItemCard(
                            item: item,
                            onBorrow: () => widget.onBorrowItem(item),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onBorrow;

  const _ItemCard({required this.item, required this.onBorrow});

  IconData _getIconData(String name) {
    switch (name) {
      case 'chair':
        return Icons.chair_alt;
      case 'projector':
        return Icons.videocam_outlined;
      case 'speaker':
        return Icons.speaker_group_outlined;
      case 'table':
        return Icons.table_bar;
      case 'laptop':
        return Icons.laptop_mac;
      case 'podium':
        return Icons.record_voice_over;
      case 'cable':
        return Icons.cable;
      case 'tools':
        return Icons.home_repair_service_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Graphic Header
          Container(
            height: 90,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconData(item.iconName),
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.qr_code, size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            item.barcode,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textSecondary,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Details Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Stock Progress & Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StockBadge(available: item.availableStock, total: item.totalStock),
                      Text(
                        'Total: ${item.totalStock}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: item.availabilityPercentage,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        item.availableStock > 0 ? AppColors.primary : AppColors.danger,
                      ),
                      minHeight: 5,
                    ),
                  ),

                  const Spacer(),

                  // Bottom Action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: item.availableStock > 0 ? onBorrow : null,
                      icon: const Icon(Icons.add_shopping_cart, size: 15),
                      label: Text(
                        item.availableStock > 0 ? 'Ajukan Peminjaman' : 'Stok Kosong',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        backgroundColor:
                            item.availableStock > 0 ? AppColors.primary : Colors.grey.shade300,
                      ),
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
