import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/services/settings_service.dart';
import '../features/templates/models/template_model.dart';
import '../features/templates/widgets/template_card.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  final _settingsService = SettingsService();
  String _selectedCategory = 'all';

  // Mock data - depois virá do backend
  final List<ServiceTemplate> _templates = [
    ServiceTemplate(
      id: '1',
      name: 'Tatuagem Colorida Pequena',
      category: 'Tatuagem',
      basePrice: 300.00,
      estimatedDuration: 120,
      description:
          'Tatuagem colorida de até 10cm. Inclui todos os materiais e uma sessão de retoque grátis.',
      includedItems: [
        TemplateItem(
          inventoryItemId: '1',
          itemName: 'Tinta Preta 30ml',
          quantity: 1,
        ),
        TemplateItem(
          inventoryItemId: '6',
          itemName: 'Tinta Colorida',
          quantity: 2,
        ),
        TemplateItem(
          inventoryItemId: '2',
          itemName: 'Agulhas RL 07',
          quantity: 3,
        ),
        TemplateItem(
          inventoryItemId: '4',
          itemName: 'Filme PVC 15cm',
          quantity: 1,
        ),
      ],
      isActive: true,
    ),
    ServiceTemplate(
      id: '2',
      name: 'Tatuagem P&B Média',
      category: 'Tatuagem',
      basePrice: 500.00,
      estimatedDuration: 180,
      description:
          'Tatuagem preta e cinza de 10-20cm. Ideal para trabalhos detalhados.',
      includedItems: [
        TemplateItem(
          inventoryItemId: '1',
          itemName: 'Tinta Preta 30ml',
          quantity: 2,
        ),
        TemplateItem(
          inventoryItemId: '2',
          itemName: 'Agulhas RL 07',
          quantity: 5,
        ),
        TemplateItem(
          inventoryItemId: '4',
          itemName: 'Filme PVC 15cm',
          quantity: 1,
        ),
      ],
      isActive: true,
    ),
    ServiceTemplate(
      id: '3',
      name: 'Piercing Tradicional',
      category: 'Piercing',
      basePrice: 80.00,
      estimatedDuration: 30,
      description: 'Piercing tradicional com joia de aço cirúrgico inclusa.',
      includedItems: [
        TemplateItem(
          inventoryItemId: '3',
          itemName: 'Luvas Nitrílicas',
          quantity: 1,
        ),
        TemplateItem(
          inventoryItemId: '5',
          itemName: 'Álcool 70%',
          quantity: 0.1,
        ),
      ],
      isActive: true,
    ),
    ServiceTemplate(
      id: '4',
      name: 'Cover Up Pequeno',
      category: 'Cover Up',
      basePrice: 400.00,
      estimatedDuration: 150,
      description: 'Cobertura de tatuagem antiga pequena (até 8cm).',
      includedItems: [
        TemplateItem(
          inventoryItemId: '1',
          itemName: 'Tinta Preta 30ml',
          quantity: 2,
        ),
        TemplateItem(
          inventoryItemId: '6',
          itemName: 'Tinta Colorida',
          quantity: 1,
        ),
        TemplateItem(
          inventoryItemId: '2',
          itemName: 'Agulhas RL 07',
          quantity: 4,
        ),
      ],
      isActive: true,
    ),
    ServiceTemplate(
      id: '5',
      name: 'Retoque Simples',
      category: 'Retoque',
      basePrice: 150.00,
      estimatedDuration: 60,
      description:
          'Retoque de tatuagem para avivar cores ou corrigir detalhes.',
      includedItems: [
        TemplateItem(
          inventoryItemId: '1',
          itemName: 'Tinta Preta 30ml',
          quantity: 1,
        ),
        TemplateItem(
          inventoryItemId: '2',
          itemName: 'Agulhas RL 07',
          quantity: 2,
        ),
      ],
      isActive: true,
    ),
  ];

  List<ServiceTemplate> get _filteredTemplates {
    if (_selectedCategory == 'all') return _templates;
    return _templates.where((t) => t.category == _selectedCategory).toList();
  }

  List<ServiceTemplate> get _activeTemplates {
    return _templates.where((t) => t.isActive).toList();
  }

  List<ServiceTemplate> get _inactiveTemplates {
    return _templates.where((t) => !t.isActive).toList();
  }

  Set<String> get _categories {
    return _templates.map((t) => t.category).toSet();
  }

  void _showItemSelector(
    BuildContext parentContext,
    List<TemplateItem> currentItems,
    Function(List<TemplateItem>) onItemsChanged,
  ) {
    // Mock - depois virá do Inventory real
    final availableItems = [
      {'id': '1', 'name': 'Tinta Preta 30ml'},
      {'id': '2', 'name': 'Agulhas RL 07'},
      {'id': '3', 'name': 'Luvas Nitrílicas'},
      {'id': '4', 'name': 'Filme PVC 15cm'},
      {'id': '5', 'name': 'Álcool 70%'},
      {'id': '6', 'name': 'Tinta Colorida'},
      {'id': '7', 'name': 'Pomada Cicatrizante'},
    ];

    List<TemplateItem> selectedItems = List.from(currentItems);

    showDialog(
      context: parentContext,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: const BorderSide(color: AppColors.primary, width: 1),
            ),
            title: const Text(
              'ADICIONAR MATERIAIS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                color: AppColors.textPrimary,
              ),
            ),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  const Text(
                    'Selecione os materiais e defina as quantidades',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableItems.length,
                      itemBuilder: (context, index) {
                        final item = availableItems[index];
                        final isSelected = selectedItems.any(
                          (si) => si.inventoryItemId == item['id'],
                        );
                        final selectedItem = selectedItems.firstWhere(
                          (si) => si.inventoryItemId == item['id'],
                          orElse: () => TemplateItem(
                            inventoryItemId: item['id']!,
                            itemName: item['name']!,
                            quantity: 1,
                          ),
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.backgroundTertiary,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedItems.add(TemplateItem(
                                        inventoryItemId: item['id']!,
                                        itemName: item['name']!,
                                        quantity: 1,
                                      ));
                                    } else {
                                      selectedItems.removeWhere(
                                        (si) =>
                                            si.inventoryItemId == item['id'],
                                      );
                                    }
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                              Expanded(
                                child: Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Qtd',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                    ),
                                    controller: TextEditingController(
                                      text: selectedItem.quantity.toString(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      final qty = double.tryParse(value) ?? 1;
                                      setState(() {
                                        final idx = selectedItems.indexWhere(
                                          (si) =>
                                              si.inventoryItemId == item['id'],
                                        );
                                        if (idx != -1) {
                                          selectedItems[idx] = TemplateItem(
                                            inventoryItemId: item['id']!,
                                            itemName: item['name']!,
                                            quantity: qty,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: () {
                  onItemsChanged(selectedItems);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('CONFIRMAR'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTemplateForm({ServiceTemplate? template}) {
    List<TemplateItem> selectedItems = template?.includedItems ?? [];

    // Pegar primeira categoria disponível ou usar a do template
    String? selectedCategory = template?.category ??
        (_settingsService.serviceCategories.isNotEmpty
            ? _settingsService.serviceCategories.first
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
              template == null ? 'NOVO SERVIÇO' : 'EDITAR SERVIÇO',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                color: AppColors.textPrimary,
              ),
            ),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'NOME',
                        hintText: 'Ex: Tatuagem Colorida Pequena',
                      ),
                      controller: TextEditingController(text: template?.name),
                    ),
                    const SizedBox(height: 16),

                    // DROPDOWN INTEGRADO COM SETTINGS
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'CATEGORIA'),
                      value: selectedCategory,
                      items: _settingsService.serviceCategories.map((cat) {
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
                              labelText: 'PREÇO BASE (R\$)',
                            ),
                            controller: TextEditingController(
                              text: template?.basePrice.toString(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'DURAÇÃO (MIN)',
                            ),
                            controller: TextEditingController(
                              text: template?.estimatedDuration.toString(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'DESCRIÇÃO',
                        hintText: 'Descreva o serviço...',
                      ),
                      controller:
                          TextEditingController(text: template?.description),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // ITENS INCLUSOS - MULTI-SELECT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'MATERIAIS INCLUSOS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _showItemSelector(
                              context,
                              selectedItems,
                              (items) {
                                setDialogState(() {
                                  selectedItems = items;
                                });
                              },
                            );
                          },
                          icon: const Icon(Icons.add, size: 14),
                          label: const Text('ADICIONAR ITEM'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Lista de itens selecionados
                    if (selectedItems.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundTertiary,
                          border: Border.all(color: AppColors.border, width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Center(
                          child: Text(
                            'Nenhum material adicionado',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundTertiary,
                          border: Border.all(color: AppColors.border, width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Column(
                          children: selectedItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.itemName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity}x',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {
                                      setDialogState(() {
                                        selectedItems.remove(item);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: AppColors.error,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
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
                        template == null
                            ? 'Serviço adicionado!'
                            : 'Serviço atualizado!',
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

  void _toggleTemplateStatus(ServiceTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(
            color: template.isActive ? AppColors.error : AppColors.success,
            width: 1,
          ),
        ),
        title: Text(
          template.isActive ? 'DESATIVAR SERVIÇO' : 'ATIVAR SERVIÇO',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          template.isActive
              ? 'Deseja desativar "${template.name}"? Ele não aparecerá mais para novos agendamentos.'
              : 'Deseja ativar "${template.name}"? Ele ficará disponível para agendamentos.',
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
                final index = _templates.indexOf(template);
                _templates[index] =
                    template.copyWith(isActive: !template.isActive);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    template.isActive
                        ? 'Serviço desativado!'
                        : 'Serviço ativado!',
                  ),
                  backgroundColor:
                      template.isActive ? AppColors.error : AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  template.isActive ? AppColors.error : AppColors.success,
            ),
            child: Text(template.isActive ? 'DESATIVAR' : 'ATIVAR'),
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
                      'SERVIÇOS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_activeTemplates.length} ativo(s) • ${_inactiveTemplates.length} inativo(s)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showTemplateForm(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('NOVO SERVIÇO'),
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

            const SizedBox(height: 40),

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

            // Active Templates
            if (_activeTemplates.isNotEmpty) ...[
              const Text(
                'ATIVOS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ...(_selectedCategory == 'all'
                      ? _activeTemplates
                      : _filteredTemplates.where((t) => t.isActive))
                  .map((template) {
                return TemplateCard(
                  template: template,
                  onEdit: () => _showTemplateForm(template: template),
                  onToggleStatus: () => _toggleTemplateStatus(template),
                );
              }),
            ],

            // Inactive Templates
            if (_inactiveTemplates.isNotEmpty) ...[
              const SizedBox(height: 40),
              const Text(
                'INATIVOS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ...(_selectedCategory == 'all'
                      ? _inactiveTemplates
                      : _filteredTemplates.where((t) => !t.isActive))
                  .map((template) {
                return TemplateCard(
                  template: template,
                  onEdit: () => _showTemplateForm(template: template),
                  onToggleStatus: () => _toggleTemplateStatus(template),
                );
              }),
            ],

            // Empty State
            if (_filteredTemplates.isEmpty)
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
                        Icons.list_alt,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nenhum serviço encontrado',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
