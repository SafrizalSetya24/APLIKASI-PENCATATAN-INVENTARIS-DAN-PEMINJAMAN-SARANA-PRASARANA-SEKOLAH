enum LoanStatus {
  pending('Menunggu Persetujuan'),
  approved('Disetujui Admin'),
  borrowed('Sedang Digunakan'),
  rejected('Ditolak'),
  returned('Sudah Dikembalikan');

  final String label;
  const LoanStatus(this.label);
}

class LoanRequest {
  final String id;
  final String borrowerName;
  final String borrowerRole; // e.g. "Ketua IPM SMK Muh Kramat", "Siswa XII RPL 1"
  final String borrowerId;   // NISN / NIP
  final String itemId;
  final String itemName;
  final String itemBarcode;
  final int quantity;
  final DateTime requestDate;
  final DateTime loanDate;
  final DateTime returnDate;
  final String purpose;
  LoanStatus status;
  String? adminNote;

  LoanRequest({
    required this.id,
    required this.borrowerName,
    required this.borrowerRole,
    required this.borrowerId,
    required this.itemId,
    required this.itemName,
    required this.itemBarcode,
    required this.quantity,
    required this.requestDate,
    required this.loanDate,
    required this.returnDate,
    required this.purpose,
    this.status = LoanStatus.pending,
    this.adminNote,
  });
}

