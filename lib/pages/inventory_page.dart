import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/services/settings_service.dart';
import '../features/inventory/models/inventory_item_model.dart';
import '../features/inventory/widgets/inventory_card.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _settingsService = SettingsService();
  String _selectedCategory = 'all';

  // Mock data - depois virá do backend
  final List<InventoryItem> _items = [
    InventoryItem(
      id: '1',
      name: 'Tinta Preta 30ml',
      category: 'Tinta',
      quantity: 5,
      minQuantity: 10,
      unit: 'unidades',
      price: 85.00,
      supplier: 'TattooSupply',
      lastRestockDate: '2026-02-01',
    ),
    InventoryItem(
      id: '2',
      name: 'Agulhas RL 07',
      category: 'Agulha',
      quantity: 50,
      minQuantity: 20,
      unit: 'unidades',
      price: 2.50,
      supplier: 'TattooSupply',
      lastRestockDate: '2026-01-15',
    ),
    InventoryItem(
      id: '3',
      name: 'Luvas Nitrílicas',
      category: 'Luva',
      quantity: 0,
      minQuantity: 100,
      unit: 'pares',
      price: 1.20,
      supplier: 'MedSupply',
      notes: 'Precisa comprar urgente',
    ),
    InventoryItem(
      id: '4',
      name: 'Filme PVC 15cm',
      category: 'Filme',
      quantity: 8,
      minQuantity: 5,
      unit: 'rolos',
      price: 12.00,
      supplier: 'TattooSupply',
      lastRestockDate: '2026-02-05',
    ),
    InventoryItem(
      id: '5',
      name: 'Álcool 70%',
      category: 'Higiene',
      quantity: 3,
      minQuantity: 5,
      unit: 'litros',
      price: 8.50,
      supplier: 'MedSupply',
    ),
  ];

  List<InventoryItem> get _filteredItems {
    if (_selectedCategory == 'all') return _items;
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  List<InventoryItem> get _lowStockItems {
    return _items.where((item) => item.isLowStock).toList();
  }

  List<InventoryItem> get _outOfStockItems {
    return _items.where((item) => item.isOutOfStock).toList();
  }

  Set<String> get _categories {
    return _items.map((item) => item.category).toSet();
  }

  void _showItemForm({InventoryItem? item}) {
    String? selectedCategory = item?.category ??
        (_settingsService.inventoryCategories.isNotEmpty
            ? _settingsService.inventoryCategories.first
            : null);

    String? selectedUnit = item?.unit ??
        (_settingsService.measurementUnits.isNotEmpty
            ? _settingsService.measurementUnits.first
            : null);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: const BorderSide(color: AppColors.primary, width: 1),
            ),
            title: Text(
              item == null ? 'NOVO ITEM' : 'EDITAR ITEM',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                color: AppColors.textPrimary,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'NOME',
                        hintText: 'Ex: Tinta Preta 30ml',
                      ),
                      controller: TextEditingController(text: item?.name),
                    ),
                    const SizedBox(height: 16),

                    // DROPDOWN CATEGORIA - INTEGRADO
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'CATEGORIA'),
                      value: selectedCategory,
                      items: _settingsService.inventoryCategories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'QUANTIDADE',
                            ),
                            controller: TextEditingController(
                              text: item?.quantity.toString(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          // DROPDOWN UNIDADE - INTEGRADO
                          child: DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: 'UNIDADE'),
                            value: selectedUnit,
                            items:
                                _settingsService.measurementUnits.map((unit) {
                              return DropdownMenuItem(
                                  value: unit, child: Text(unit));
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedUnit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'QUANTIDADE MÍNIMA',
                        helperText: 'Alerta quando atingir este valor',
                      ),
                      controller: TextEditingController(
                        text: item?.minQuantity.toString(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'PREÇO UNITÁRIO (R\$)',
                      ),
                      controller: TextEditingController(
                        text: item?.price?.toString(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'FORNECEDOR',
                        hintText: 'Ex: TattooSupply',
                      ),
                      controller: TextEditingController(text: item?.supplier),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'OBSERVAÇÕES',
                      ),
                      controller: TextEditingController(text: item?.notes),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        item == null ? 'Item adicionado!' : 'Item atualizado!',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('SALVAR'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddStockDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.primary, width: 1),
        ),
        title: const Text(
          'ADICIONAR ESTOQUE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item: ${item.name}',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Estoque atual: ${item.quantity} ${item.unit}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'QUANTIDADE A ADICIONAR',
                hintText: '0',
                suffixText: item.unit,
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Estoque atualizado!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('ADICIONAR'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.error, width: 1),
        ),
        title: const Text(
          'EXCLUIR ITEM',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Deseja realmente excluir "${item.name}"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.remove(item);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item excluído!'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESTOQUE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_items.length} item(ns) • ${_lowStockItems.length} baixo • ${_outOfStockItems.length} esgotado',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showItemForm(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('NOVO ITEM'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Alerts
            if (_outOfStockItems.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  border: Border.all(color: AppColors.error, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.error, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${_outOfStockItems.length} item(ns) esgotado(s): ${_outOfStockItems.map((i) => i.name).join(', ')}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (_lowStockItems.isNotEmpty && _outOfStockItems.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  border: Border.all(color: AppColors.warning, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: AppColors.warning, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${_lowStockItems.length} item(ns) com estoque baixo',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Category Filter
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('TODOS', 'all'),
                    ..._categories.map(
                        (cat) => _buildFilterButton(cat.toUpperCase(), cat)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Items List
            if (_filteredItems.isEmpty)
              Container(
                padding: const EdgeInsets.all(60),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nenhum item encontrado',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._filteredItems.map((item) {
                return InventoryCard(
                  item: item,
                  onEdit: () => _showItemForm(item: item),
                  onAddStock: () => _showAddStockDialog(item),
                  onDelete: () => _deleteItem(item),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isActive = _selectedCategory == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
