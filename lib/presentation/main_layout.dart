import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/models/inventory_item.dart';
import '../core/models/loan_request.dart';
import '../data/mock_data.dart';
import 'pages/admin/admin_dashboard_page.dart';
import 'pages/admin/inventory_management_page.dart';
import 'pages/admin/loan_approvals_page.dart';
import 'pages/user/catalog_page.dart';
import 'pages/user/my_loans_page.dart';
import 'widgets/barcode_scanner_modal.dart';
import 'widgets/chatbot_widget.dart';
import 'widgets/custom_sidebar.dart';
import 'widgets/loan_submission_dialog.dart';
import 'widgets/school_header.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserRole _currentRole = UserRole.borrower;
  int _userNavIndex = 0;
  int _adminNavIndex = 0;
  String _searchQuery = '';

  late List<InventoryItem> _items;
  late List<LoanRequest> _loanRequests;

  @override
  void initState() {
    super.initState();
    _items = List.from(MockData.items);
    _loanRequests = List.from(MockData.initialLoanRequests);
  }

  int get _pendingApprovalCount =>
      _loanRequests.where((r) => r.status == LoanStatus.pending).length;

  void _openBarcodeScanner() {
    showDialog(
      context: context,
      builder: (context) {
        return BarcodeScannerModal(
          onItemScanned: (item) {
            _openLoanSubmissionDialog(item);
          },
        );
      },
    );
  }

  void _openLoanSubmissionDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return LoanSubmissionDialog(
          item: item,
          onSubmit: (newRequest) {
            setState(() {
              _loanRequests.insert(0, newRequest);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pengajuan peminjaman ${item.name} (${newRequest.quantity} unit) berhasil dikirim! Menunggu persetujuan Admin Sarpras.',
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primary,
                duration: const Duration(seconds: 4),
              ),
            );
          },
        );
      },
    );
  }

  void _handleQuickDecision(LoanRequest request, bool approve) {
    setState(() {
      request.status = approve ? LoanStatus.approved : LoanStatus.rejected;
      request.adminNote = approve
          ? 'Disetujui langsung oleh Admin Sarpras via Dashboard.'
          : 'Ditolak via Dashboard: Fasilitas tidak tersedia pada jadwal.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approve
              ? 'Pengajuan ${request.borrowerName} telah Disetujui!'
              : 'Pengajuan ${request.borrowerName} Ditolak.',
        ),
        backgroundColor: approve ? AppColors.success : AppColors.danger,
      ),
    );
  }

  void _handleUpdateRequestStatus(LoanRequest request, LoanStatus status, String? note) {
    setState(() {
      request.status = status;
      if (note != null) request.adminNote = note;

      // Update item available stocks if borrowed or returned
      final itemIndex = _items.indexWhere((i) => i.id == request.itemId);
      if (itemIndex != -1) {
        final current = _items[itemIndex];
        if (status == LoanStatus.borrowed) {
          final newAvailable = (current.availableStock - request.quantity).clamp(0, current.totalStock);
          final newBorrowed = current.borrowedStock + request.quantity;
          _items[itemIndex] = InventoryItem(
            id: current.id,
            barcode: current.barcode,
            name: current.name,
            category: current.category,
            location: current.location,
            totalStock: current.totalStock,
            availableStock: newAvailable,
            borrowedStock: newBorrowed,
            condition: current.condition,
            description: current.description,
            iconName: current.iconName,
          );
        } else if (status == LoanStatus.returned) {
          final newAvailable = (current.availableStock + request.quantity).clamp(0, current.totalStock);
          final newBorrowed = (current.borrowedStock - request.quantity).clamp(0, current.totalStock);
          _items[itemIndex] = InventoryItem(
            id: current.id,
            barcode: current.barcode,
            name: current.name,
            category: current.category,
            location: current.location,
            totalStock: current.totalStock,
            availableStock: newAvailable,
            borrowedStock: newBorrowed,
            condition: current.condition,
            description: current.description,
            iconName: current.iconName,
          );
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pengajuan ${request.id} diperbarui menjadi: ${status.label}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _onNavigationSelected(int index) {
    setState(() {
      if (_currentRole == UserRole.borrower) {
        if (index == 1) {
          _openBarcodeScanner();
        } else {
          _userNavIndex = index;
        }
      } else {
        _adminNavIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isMobile = screenWidth < 768;

    final currentNavIndex = _currentRole == UserRole.borrower
        ? _userNavIndex
        : _adminNavIndex;

    final sidebarWidget = CustomSidebar(
      currentRole: _currentRole,
      selectedIndex: currentNavIndex,
      pendingApprovalCount: _pendingApprovalCount,
      onItemSelected: (index) {
        if (!isDesktop && _scaffoldKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop(); // Close drawer
        }
        _onNavigationSelected(index);
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      drawer: isDesktop ? null : Drawer(child: sidebarWidget),
      body: Stack(
        children: [
          Row(
            children: [
              // Pinned Sidebar only on Desktop
              if (isDesktop) sidebarWidget,

              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Sticky Header with school branding, search, & role switcher
                    SchoolHeader(
                      currentRole: _currentRole,
                      pendingNotificationCount: _pendingApprovalCount,
                      onRoleChanged: (role) {
                        setState(() {
                          _currentRole = role;
                        });
                      },
                      onScanBarcodePressed: _openBarcodeScanner,
                      onSearchChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      onNotificationsPressed: () {
                        setState(() {
                          _currentRole = UserRole.admin;
                          _adminNavIndex = 1; // Navigasi ke Halaman Persetujuan
                        });
                      },
                      onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),

                    // Page Body
                    Expanded(
                      child: Container(
                        color: AppColors.background,
                        child: _buildCurrentPage(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Floating Chatbot Widget (Always available at bottom right)
          ChatbotWidget(isMobile: isMobile),
        ],
      ),
      // Bottom Navigation Bar for Mobile Web
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: currentNavIndex.clamp(0, 2),
              onDestinationSelected: (idx) => _onNavigationSelected(idx),
              indicatorColor: AppColors.primaryLight,
              destinations: _currentRole == UserRole.borrower
                  ? [
                      const NavigationDestination(
                        icon: Icon(Icons.grid_view_outlined),
                        selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
                        label: 'Katalog',
                      ),
                      const NavigationDestination(
                        icon: Icon(Icons.qr_code_scanner),
                        selectedIcon: Icon(Icons.qr_code_scanner, color: AppColors.primary),
                        label: 'Scan Barcode',
                      ),
                      const NavigationDestination(
                        icon: Icon(Icons.receipt_long_outlined),
                        selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                        label: 'Riwayat',
                      ),
                    ]
                  : [
                      const NavigationDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
                        label: 'Dashboard',
                      ),
                      NavigationDestination(
                        icon: Badge(
                          isLabelVisible: _pendingApprovalCount > 0,
                          label: Text('$_pendingApprovalCount'),
                          child: const Icon(Icons.notifications_active_outlined),
                        ),
                        selectedIcon: Badge(
                          isLabelVisible: _pendingApprovalCount > 0,
                          label: Text('$_pendingApprovalCount'),
                          child: const Icon(Icons.notifications_active, color: AppColors.primary),
                        ),
                        label: 'Persetujuan',
                      ),
                      const NavigationDestination(
                        icon: Icon(Icons.inventory_2_outlined),
                        selectedIcon: Icon(Icons.inventory_2_rounded, color: AppColors.primary),
                        label: 'Inventaris',
                      ),
                    ],
            )
          : null,
    );
  }

  Widget _buildCurrentPage() {
    if (_currentRole == UserRole.borrower) {
      switch (_userNavIndex) {
        case 0:
          return CatalogPage(
            items: _items,
            searchQuery: _searchQuery,
            onBorrowItem: (item) => _openLoanSubmissionDialog(item),
            onScanBarcode: _openBarcodeScanner,
          );
        case 2:
          return MyLoansPage(loanRequests: _loanRequests);
        default:
          return CatalogPage(
            items: _items,
            searchQuery: _searchQuery,
            onBorrowItem: (item) => _openLoanSubmissionDialog(item),
            onScanBarcode: _openBarcodeScanner,
          );
      }
    } else {
      switch (_adminNavIndex) {
        case 0:
          return AdminDashboardPage(
            items: _items,
            loanRequests: _loanRequests,
            onGoToApprovals: () => setState(() => _adminNavIndex = 1),
            onQuickDecision: _handleQuickDecision,
          );
        case 1:
          return LoanApprovalsPage(
            loanRequests: _loanRequests,
            onUpdateRequestStatus: _handleUpdateRequestStatus,
          );
        case 2:
          return InventoryManagementPage(
            items: _items,
            onAddItem: (newItem) {
              setState(() => _items.insert(0, newItem));
            },
            onEditItem: (updated) {
              setState(() {
                final idx = _items.indexWhere((i) => i.id == updated.id);
                if (idx != -1) _items[idx] = updated;
              });
            },
            onDeleteItem: (id) {
              setState(() => _items.removeWhere((i) => i.id == id));
            },
          );
        default:
          return AdminDashboardPage(
            items: _items,
            loanRequests: _loanRequests,
            onGoToApprovals: () => setState(() => _adminNavIndex = 1),
            onQuickDecision: _handleQuickDecision,
          );
      }
    }
  }
}
