# SARPRAS SMK MUHAMMADIYAH KRAMAT
## Aplikasi Pencatatan Inventaris dan Peminjaman Sarana Prasarana Sekolah (Flutter Web)

Aplikasi Web modern berbasis **Flutter** untuk tugas **Capstone Project**, berkolaborasi dengan mitra sekolah **SMK Muhammadiyah Kramat**. Sistem ini dirancang untuk mendigitalkan proses pencatatan aset inventaris sekolah serta alur peminjaman sarana prasarana (kursi aula, sound system, proyektor, peralatan praktikum bengkel/lab, dll.) melalui pemindaian barcode fisik dan sistem verifikasi persetujuan admin.

---

### 🌟 Fitur Utama UI yang Telah Dibuat:

1. **Ketersediaan Fasilitas & Katalog Sarpras (User View)**
   - Filter kategori barang (*Furniture & Mebel*, *Elektronik & Multimedia*, *Alat Praktik Kejuruan*, *Perlengkapan Acara*).
   - Indikator ketersediaan real-time (*Tersedia*, *Stok Menipis*, *Stok Habis*) dengan progress bar visual.
   - Pencarian cepat berdasarkan nama barang, kode barcode, atau lokasi penyimpanan.

2. **Simulasi Scan Barcode Interaktif**
   - Modal viewfinder kamera dengan animasi laser pemindai hijau.
   - Pilihan sampel barcode instan (*Kursi Lipat Aula*, *Proyektor*, *Sound System*, dll.) untuk mempermudah demonstrasi pengujian tanpa perlu hardware scanner fisik.
   - Fitur input barcode manual jika kamera tidak tersedia.
   - Mengarahkan langsung barang hasil scan ke formulir peminjaman.

3. **Formulir Pengajuan Peminjaman Sarpras**
   - Data barang terisi otomatis setelah barcode dipindai.
   - Input nama peminjam, NISN/NIP, dan unit organisasi (IPM, Hizbul Wathan, Tapak Suci, Guru, dsb.).
   - Pengatur jumlah barang (*counter unit*) dengan validasi batas stok tersedia.
   - Pemilihan tanggal pengambilan dan rencana tanggal pengembalian (*Date Picker*).
   - Pengisian keterangan keperluan acara sekolah.

4. **Sistem Notifikasi & Persetujuan Admin (Approval Queue)**
   - **Dashboard Admin Sarpras**: Kartu ringkasan metrik (Total Aset, Barang Tersedia, Pengajuan Menunggu Konfirmasi, Fasilitas Sedang Dipinjam).
   - **Antrean Notifikasi Persetujuan**: Menampilkan detail peminjam, jumlah unit, dan keperluan acara.
   - **Aksi Cepat Admin**: Tombol *Setujui (Approve)* dan *Tolak (Reject)* lengkap dengan dialog catatan persetujuan dari petugas sarpras.
   - **Status Serah Terima & Pengembalian**: Konfirmasi barang telah diserahkan dan verifikasi pengembalian fasilitas.

5. **Chatbot Asisten Pintar Sarpras**
   - Tombol floating chat modern di pojok kanan bawah yang selalu siap digunakan.
   - Opsi pertanyaan cepat (*quick prompt chips*): Ketersediaan kursi aula, jam operasional sarpras, alur & syarat peminjaman.
   - Percakapan simulasi respons cerdas dengan format balon pesan yang menarik.

6. **Riwayat Peminjaman & Bukti QR Tiket Digital (User View)**
   - Riwayat status: *Menunggu Persetujuan*, *Disetujui*, *Sedang Digunakan*, *Selesai*, *Ditolak*.
   - Modal *Bukti QR Tiket Digital* yang dapat ditunjukkan peminjam kepada petugas sarpras sekolah saat serah terima barang.

7. **Master Data & Pencatatan Inventaris (Admin View)**
   - Tabel master data sarpras sekolah SMK Muhammadiyah Kramat.
   - Fitur modal *Tambah Fasilitas Baru* dan *Edit Data*.
   - Fitur *Preview Cetak Label Barcode & QR Code* fasilitas resmi sekolah.

8. **Role Switcher Praktis**
   - Tombol toggle di bagian header untuk berganti peran antara **Mode Peminjam (Siswa/Guru)** dan **Mode Admin Sarpras** secara langsung saat demonstrasi pengujian capstone.

---

### 📁 Struktur Folder Proyek:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # Palet warna identitas hijau Muhammadiyah & aksen emas
│   │   └── app_theme.dart        # Tema Material 3 & tipografi Google Fonts (Plus Jakarta Sans)
│   └── models/
│       ├── inventory_item.dart   # Model data barang & ketersediaan stok
│       ├── loan_request.dart     # Model permohonan pinjam & status persetujuan
│       └── chat_message.dart     # Model pesan interaksi chatbot
├── data/
│   └── mock_data.dart            # Data sampel realistik sarpras SMK Muhammadiyah Kramat
├── presentation/
│   ├── widgets/
│   │   ├── school_header.dart          # Header navigasi, pencarian, switcher role, notifikasi
│   │   ├── custom_sidebar.dart         # Sidebar navigasi panel peminjam & panel admin
│   │   ├── barcode_scanner_modal.dart  # Modal interaktif scanner barcode dengan animasi laser
│   │   ├── loan_submission_dialog.dart # Form pengajuan peminjaman barang
│   │   ├── chatbot_widget.dart         # Floating AI Chatbot interaktif
│   │   ├── stat_card.dart              # Komponen kartu statistik metrik
│   │   └── status_badge.dart           # Badge warna-warni status persetujuan & stok
│   ├── pages/
│   │   ├── user/
│   │   │   ├── catalog_page.dart       # Halaman katalog ketersediaan barang
│   │   │   └── my_loans_page.dart      # Halaman riwayat peminjaman & tiket digital
│   │   └── admin/
│   │       ├── admin_dashboard_page.dart         # Halaman ringkasan dashboard sarpras
│   │       ├── loan_approvals_page.dart          # Halaman notifikasi persetujuan admin
│   │       └── inventory_management_page.dart    # Halaman master pencatatan barang & cetak barcode
│   └── main_layout.dart          # Layout utama yang menghubungkan seluruh halaman & widget
└── main.dart                     # Entrypoint aplikasi dengan lokalisasi bahasa Indonesia
```

---

### 🚀 Cara Menjalankan Aplikasi Web:

1. Buka terminal di folder proyek ini.
2. Jalankan perintah:
   ```bash
   flutter run -d chrome
   ```
   atau jalankan di web server bawaan Flutter:
   ```bash
   flutter run -d web-server --web-port=8080
   ```
3. Buka browser pada alamat yang ditampilkan (misal: `http://localhost:8080`).

---

### 💡 Panduan Integrasi Fitur / Backend Nanti:
Untuk menghubungkan formulir dan notifikasi dengan database nyata (misal: Supabase, Firebase, atau REST API backend Laravel/Express):
- **Data Barang**: Hubungkan fungsi pemanggilan `items` di [`main_layout.dart`](file:///c:/Users/Dyonnnn/Documents/Kuliah/Capstone/APLIKASI%20PENCATATAN%20INVENTARIS%20DAN%20PEMINJAMAN%20SARANA%20PRASARANA%20SEKOLAH/lib/presentation/main_layout.dart) ke API endpoint `GET /api/inventory`.
- **Pengajuan Peminjaman**: Pada method `_openLoanSubmissionDialog`, hubungkan callback `onSubmit` ke `POST /api/loans`.
- **Persetujuan Admin**: Pada method `_handleUpdateRequestStatus`, kirim perubahan status ke `PATCH /api/loans/{id}/status`.
- **Scan Barcode Hardware / Kamera**: Paket seperti `mobile_scanner` atau pembaca barcode scanner USB dapat langsung mengirim string barcode ke fungsi `_handleSelectBarcode` di [`barcode_scanner_modal.dart`](file:///c:/Users/Dyonnnn/Documents/Kuliah/Capstone/APLIKASI%20PENCATATAN%20INVENTARIS%20DAN%20PEMINJAMAN%20SARANA%20PRASARANA%20SEKOLAH/lib/presentation/widgets/barcode_scanner_modal.dart).
