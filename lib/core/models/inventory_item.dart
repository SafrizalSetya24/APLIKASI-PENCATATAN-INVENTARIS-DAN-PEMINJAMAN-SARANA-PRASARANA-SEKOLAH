enum ItemCategory {
  furniture('Furniture & Mebel'),
  elektronik('Elektronik & Multimedia'),
  alatPraktik('Alat Praktik Kejuruan'),
  perlengkapan('Perlengkapan Acara');

  final String label;
  const ItemCategory(this.label);
}

class InventoryItem {
  final String id;
  final String barcode;
  final String name;
  final String category;
  final String location;
  final int totalStock;
  final int availableStock;
  final int borrowedStock;
  final int maintenanceStock;
  final String condition;
  final String description;
  final String iconName;

  const InventoryItem({
    required this.id,
    required this.barcode,
    required this.name,
    required this.category,
    required this.location,
    required this.totalStock,
    required this.availableStock,
    required this.borrowedStock,
    this.maintenanceStock = 0,
    required this.condition,
    required this.description,
    this.iconName = 'chair',
  });

  bool get isAvailable => availableStock > 0;
  double get availabilityPercentage =>
      totalStock > 0 ? (availableStock / totalStock) : 0.0;
}

