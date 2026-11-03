import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/inventory_item.dart';
import '../../core/models/loan_request.dart';

class LoanSubmissionDialog extends StatefulWidget {
  final InventoryItem item;
  final Function(LoanRequest request) onSubmit;

  const LoanSubmissionDialog({
    super.key,
    required this.item,
    required this.onSubmit,
  });

  @override
  State<LoanSubmissionDialog> createState() => _LoanSubmissionDialogState();
}

class _LoanSubmissionDialogState extends State<LoanSubmissionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Ahmad Fauzi');
  final _roleController = TextEditingController(text: 'Siswa / Perwakilan IPM');
  final _idController = TextEditingController(text: 'NISN: 0081293819');
  final _purposeController = TextEditingController(
    text: 'Kegiatan pengajian dan rapat kerja organisasi di Aula KH Ahmad Dahlan.',
  );

  int _quantity = 1;
  DateTime _loanDate = DateTime.now().add(const Duration(days: 1));
  DateTime _returnDate = DateTime.now().add(const Duration(days: 2));
  bool _agreedToTerms = true;

  @override
  void initState() {
    super.initState();
    // Default quantity reasonable for chairs or single items
    if (widget.item.category.contains('Furniture')) {
      _quantity = widget.item.availableStock >= 25 ? 25 : widget.item.availableStock;
    } else {
      _quantity = 1;
    }
    if (_quantity < 1 && widget.item.availableStock > 0) {
      _quantity = 1;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _idController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isLoanDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isLoanDate ? _loanDate : _returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isLoanDate) {
          _loanDate = picked;
          if (_returnDate.isBefore(_loanDate)) {
            _returnDate = _loanDate.add(const Duration(days: 1));
          }
        } else {
          if (picked.isAfter(_loanDate) || picked.isAtSameMomentAs(_loanDate)) {
            _returnDate = picked;
          }
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui ketentuan peminjaman sarpras.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final newRequest = LoanRequest(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      borrowerName: _nameController.text.trim(),
      borrowerRole: _roleController.text.trim(),
      borrowerId: _idController.text.trim(),
      itemId: widget.item.id,
      itemName: widget.item.name,
      itemBarcode: widget.item.barcode,
      quantity: _quantity,
      requestDate: DateTime.now(),
      loanDate: _loanDate,
      returnDate: _returnDate,
      purpose: _purposeController.text.trim(),
      status: LoanStatus.pending,
    );

    widget.onSubmit(newRequest);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 24, vertical: 18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 780),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 18.0 : 26.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Modal Title
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
                          child: const Icon(Icons.assignment_add, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMobile ? 'Pengajuan Pinjam' : 'Formulir Pengajuan Peminjaman',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'SMK Muhammadiyah Kramat',
                              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
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
                const SizedBox(height: 14),

                // Scanned Item Info Banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.qr_code_2, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Barcode: ${widget.item.barcode} • ${widget.item.location}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Sisa: ${widget.item.availableStock}',
                          style: const TextStyle(
                            color: Color(0xFF15803D),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Peminjam Info (Stack on mobile, Row on desktop)
                        if (isMobile) ...[
                          const Text('Nama Lengkap Peminjam *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline, size: 18),
                              hintText: 'Nama lengkap',
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 10),
                          const Text('NISN / NBM / NIP *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _idController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.badge_outlined, size: 18),
                              hintText: 'NISN / NBM',
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Nama Lengkap Peminjam *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person_outline, size: 18),
                                        hintText: 'Masukkan nama lengkap',
                                      ),
                                      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('NISN / NBM / NIP *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _idController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.badge_outlined, size: 18),
                                        hintText: 'NISN / NBM',
                                      ),
                                      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 12),

                        // Role / Unit
                        const Text(
                          'Kelas / Unit Organisasi *',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _roleController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.school_outlined, size: 18),
                            hintText: 'Contoh: IPM SMK Muh Kramat / Kelas XII RPL 1',
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 14),

                        // Jumlah Unit Peminjaman
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jumlah Unit Dipinjam *',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                IconButton.filledTonal(
                                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                                  icon: const Icon(Icons.remove, size: 16),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 65,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton.filledTonal(
                                  onPressed: _quantity < widget.item.availableStock
                                      ? () => setState(() => _quantity++)
                                      : null,
                                  icon: const Icon(Icons.add, size: 16),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Maks: ${widget.item.availableStock} unit',
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Tanggal Peminjaman & Pengembalian
                        if (isMobile) ...[
                          const Text('Tanggal Pengambilan *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _pickDate(true),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(DateFormat('dd/MM/yyyy').format(_loanDate), style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Tanggal Rencana Kembali *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _pickDate(false),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.event_repeat, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(DateFormat('dd/MM/yyyy').format(_returnDate), style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tanggal Pengambilan *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    InkWell(
                                      onTap: () => _pickDate(true),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.border),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                            const SizedBox(width: 8),
                                            Text(DateFormat('dd/MM/yyyy').format(_loanDate), style: const TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tanggal Rencana Kembali *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    InkWell(
                                      onTap: () => _pickDate(false),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.border),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.event_repeat, size: 16, color: AppColors.primary),
                                            const SizedBox(width: 8),
                                            Text(DateFormat('dd/MM/yyyy').format(_returnDate), style: const TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 12),

                        // Keterangan / Keperluan Peminjaman
                        const Text(
                          'Keterangan & Keperluan Acara *',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _purposeController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'Contoh: Untuk keperluan acara pengajian akbar di aula...',
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 10),

                        // Checkbox Agreement
                        CheckboxListTile(
                          value: _agreedToTerms,
                          onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          activeColor: AppColors.primary,
                          title: const Text(
                            'Saya bertanggung jawab menjaga fasilitas sarpras sekolah.',
                            style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: widget.item.availableStock > 0 ? _submit : null,
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: Text(isMobile ? 'Kirim' : 'Kirim Pengajuan Peminjaman'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
