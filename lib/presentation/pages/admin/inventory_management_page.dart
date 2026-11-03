import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/inventory_item.dart';

class InventoryManagementPage extends StatefulWidget {
  final List<InventoryItem> items;
  final Function(InventoryItem newItem) onAddItem;
  final Function(InventoryItem updatedItem) onEditItem;
  final Function(String id) onDeleteItem;

  const InventoryManagementPage({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onEditItem,
    required this.onDeleteItem,
  });

  @override
  State<InventoryManagementPage> createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Furniture & Mebel',
    'Elektronik & Multimedia',
    'Alat Praktik Kejuruan',
    'Perlengkapan Acara',
  ];

  void _showAddEditDialog({InventoryItem? editItem}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: editItem?.name ?? '');
    final barcodeController = TextEditingController(
      text: editItem?.barcode ?? '899100${1000 + widget.items.length + 1}',
    );
    final locationController = TextEditingController(
      text: editItem?.location ?? 'Gudang Sarpras SMK Lantai 1',
    );
    final totalStockController = TextEditingController(
      text: editItem != null ? '${editItem.totalStock}' : '10',
    );
    final availableStockController = TextEditingController(
      text: editItem != null ? '${editItem.availableStock}' : '10',
    );
    final descController = TextEditingController(text: editItem?.description ?? '');

    String category = editItem?.category ?? 'Furniture & Mebel';
    String condition = editItem?.condition ?? 'Sangat Baik';

    showDialog(
      context: context,
      builder: (context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final bool isMobile = screenWidth < 600;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              backgroundColor: AppColors.surface,
              insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                editItem == null
                                    ? (isMobile ? 'Tambah Fasilitas' : 'Tambah Sarpras Baru')
                                    : 'Edit Data Fasilitas',
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const Divider(height: 18),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Fasilitas / Barang *',
                              hintText: 'Contoh: Kursi Lipat Chitose Aula',
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          if (isMobile) ...[
                            TextFormField(
                              controller: barcodeController,
                              decoration: const InputDecoration(
                                labelText: 'Kode Barcode *',
                                prefixIcon: Icon(Icons.qr_code, size: 18),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: category,
                              decoration: const InputDecoration(labelText: 'Kategori'),
                              items: _categories
                                  .where((c) => c != 'Semua')
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12.5))))
                                  .toList(),
                              onChanged: (val) => setDialogState(() => category = val!),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: barcodeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Kode Barcode *',
                                      hintText: '8991001...',
                                      prefixIcon: Icon(Icons.qr_code, size: 18),
                                    ),
                                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: category,
                                    decoration: const InputDecoration(labelText: 'Kategori'),
                                    items: _categories
                                        .where((c) => c != 'Semua')
                                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12.5))))
                                        .toList(),
                                    onChanged: (val) => setDialogState(() => category = val!),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              labelText: 'Lokasi Penyimpanan / Ruangan *',
                              prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          if (isMobile) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: totalStockController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'Total Stok'),
                                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: availableStockController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'Stok Tersedia'),
                                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: condition,
                              decoration: const InputDecoration(labelText: 'Kondisi'),
                              items: ['Sangat Baik', 'Baik', 'Perlu Perbaikan']
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12.5))))
                                  .toList(),
                              onChanged: (val) => setDialogState(() => condition = val!),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: totalStockController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'Total Stok'),
                                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: availableStockController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'Stok Tersedia'),
                                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: condition,
                                    decoration: const InputDecoration(labelText: 'Kondisi'),
                                    items: ['Sangat Baik', 'Baik', 'Perlu Perbaikan']
                                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12.5))))
                                        .toList(),
                                    onChanged: (val) => setDialogState(() => condition = val!),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: descController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Deskripsi Fasilitas',
                              hintText: 'Keterangan merk, kondisi fisik, dsb.',
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Batal'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (!formKey.currentState!.validate()) return;
                                  final total = int.tryParse(totalStockController.text) ?? 10;
                                  final avail = int.tryParse(availableStockController.text) ?? total;

                                  final item = InventoryItem(
                                    id: editItem?.id ?? 'SAR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                                    barcode: barcodeController.text.trim(),
                                    name: nameController.text.trim(),
                                    category: category,
                                    location: locationController.text.trim(),
                                    totalStock: total,
                                    availableStock: avail,
                                    borrowedStock: editItem != null ? editItem.borrowedStock : 0,
                                    maintenanceStock: editItem != null ? editItem.maintenanceStock : 0,
                                    condition: condition,
                                    description: descController.text.trim(),
                                    iconName: editItem?.iconName ?? 'chair',
                                  );

                                  if (editItem == null) {
                                    widget.onAddItem(item);
                                  } else {
                                    widget.onEditItem(item);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(editItem == null ? 'Simpan' : 'Perbarui'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBarcodeLabel(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Label Barcode Inventaris',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Text(
                    'SMK MUHAMMADIYAH KRAMAT',
                    style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.qr_code_2, size: 90, color: Colors.black87),
                        const SizedBox(height: 4),
                        Text(
                          item.barcode,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.location,
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Tutup'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Simulasi cetak label barcode berhasil dikirim.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text('Cetak'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 680;

    final filtered = widget.items.where((i) {
      final matchesSearch = _searchQuery.isEmpty ||
          i.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.barcode.contains(_searchQuery) ||
          i.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == 'Semua' || i.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Padding(
      padding: EdgeInsets.all(isMobile ? 14.0 : 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Responsive Column on Mobile, Row on Desktop)
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Master Inventaris Sarpras',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Pencatatan sarpras SMK Muhammadiyah Kramat',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Tambah Fasilitas Baru'),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Master Inventaris Sarana Prasarana',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Pencatatan data sarpras, pelabelan barcode & pantauan kondisi fasilitas',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddEditDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Fasilitas Baru'),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Search and Filters (Stacked on mobile, row on desktop)
          if (isMobile) ...[
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: const InputDecoration(
                hintText: 'Cari fasilitas, barcode, ruang...',
                prefixIcon: Icon(Icons.search, size: 18),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12.5)))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      hintText: 'Cari fasilitas, kode barcode, atau ruangan...',
                      prefixIcon: Icon(Icons.search, size: 20),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Inventory Table Card
          Expanded(
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 54, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            const Text(
                              'Tidak Ada Data Barang',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(AppColors.surfaceVariant),
                            horizontalMargin: 16,
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('Barcode & ID', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Nama Sarpras', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Lokasi Ruang', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Stok (Ada / Total)', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Kondisi', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: filtered.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      children: [
                                        const Icon(Icons.qr_code, size: 15, color: AppColors.primary),
                                        const SizedBox(width: 5),
                                        Text(
                                          item.barcode,
                                          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                  DataCell(Text(item.category, style: const TextStyle(fontSize: 12.5))),
                                  DataCell(Text(item.location, style: const TextStyle(fontSize: 12.5))),
                                  DataCell(
                                    Text(
                                      '${item.availableStock} / ${item.totalStock} Unit',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.5,
                                        color: item.availableStock > 0 ? AppColors.primaryDark : AppColors.danger,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: item.condition.contains('Sangat')
                                            ? AppColors.successLight
                                            : AppColors.warningLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.condition,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: item.condition.contains('Sangat')
                                              ? const Color(0xFF15803D)
                                              : const Color(0xFFB45309),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.qr_code_2, size: 17, color: AppColors.primary),
                                          tooltip: 'Cetak Barcode',
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                          onPressed: () => _showBarcodeLabel(item),
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 17, color: AppColors.info),
                                          tooltip: 'Edit Data',
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                          onPressed: () => _showAddEditDialog(editItem: item),
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 17, color: AppColors.danger),
                                          tooltip: 'Hapus Fasilitas',
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                          onPressed: () => widget.onDeleteItem(item.id),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
