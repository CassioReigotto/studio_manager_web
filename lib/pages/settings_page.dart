import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/services/settings_service.dart';
import '../features/settings/widgets/config_section.dart';
import '../features/settings/widgets/config_item_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settingsService = SettingsService();
  final _studioNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _studioNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _loadSettings() {
    final settings = _settingsService.settings;
    _studioNameController.text = settings.studioName;
    _addressController.text = settings.address ?? '';
    _phoneController.text = settings.phone ?? '';
    _emailController.text = settings.email ?? '';
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  void _addItem(String section, Function(String) addFunction) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.primary, width: 1),
        ),
        title: Text(
          'ADICIONAR $section'.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'NOME',
            hintText: 'Digite o nome...',
          ),
          autofocus: true,
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
              if (controller.text.isNotEmpty) {
                addFunction(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item adicionado!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('ADICIONAR'),
          ),
        ],
      ),
    );
  }

  void _removeItem(String item, Function(String) removeFunction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.error, width: 1),
        ),
        title: const Text(
          'REMOVER ITEM',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Deseja realmente remover "$item"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              removeFunction(item);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item removido!'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('REMOVER'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    _settingsService.updateStudioInfo(
      studioName: _studioNameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações salvas com sucesso!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settingsService.settings;

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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONFIGURAÇÕES',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Personalize o sistema de acordo com seu estúdio',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('SALVAR TUDO'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Informações do Estúdio
            ConfigSection(
              title: 'Informações do Estúdio',
              description:
                  'Dados básicos que aparecem em relatórios e documentos',
              children: [
                TextField(
                  controller: _studioNameController,
                  decoration: const InputDecoration(
                    labelText: 'NOME DO ESTÚDIO',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'ENDEREÇO',
                    hintText: 'Rua, número, bairro, cidade',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'TELEFONE',
                          hintText: '(00) 00000-0000',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-MAIL',
                          hintText: 'contato@studio.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Categorias de Serviços
            ConfigSection(
              title: 'Categorias de Serviços',
              description: 'Tipos de serviços oferecidos (usado em Templates)',
              children: [
                ...settings.serviceCategories.map((cat) {
                  return ConfigItemCard(
                    item: cat,
                    onDelete: () => _removeItem(
                      cat,
                      _settingsService.removeServiceCategory,
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _addItem(
                    'categoria',
                    _settingsService.addServiceCategory,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('ADICIONAR CATEGORIA'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            // Categorias de Estoque
            ConfigSection(
              title: 'Categorias de Estoque',
              description: 'Tipos de materiais no inventário',
              children: [
                ...settings.inventoryCategories.map((cat) {
                  return ConfigItemCard(
                    item: cat,
                    onDelete: () => _removeItem(
                      cat,
                      _settingsService.removeInventoryCategory,
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _addItem(
                    'categoria',
                    _settingsService.addInventoryCategory,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('ADICIONAR CATEGORIA'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            // Unidades de Medida
            ConfigSection(
              title: 'Unidades de Medida',
              description: 'Unidades usadas no controle de estoque',
              children: [
                ...settings.measurementUnits.map((unit) {
                  return ConfigItemCard(
                    item: unit,
                    onDelete: () => _removeItem(
                      unit,
                      _settingsService.removeMeasurementUnit,
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _addItem(
                    'unidade',
                    _settingsService.addMeasurementUnit,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('ADICIONAR UNIDADE'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            // Categorias Financeiras
            ConfigSection(
              title: 'Categorias Financeiras',
              description: 'Categorias de receitas e despesas',
              children: [
                ...settings.financialCategories.map((cat) {
                  return ConfigItemCard(
                    item: cat,
                    onDelete: () => _removeItem(
                      cat,
                      _settingsService.removeFinancialCategory,
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _addItem(
                    'categoria',
                    _settingsService.addFinancialCategory,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('ADICIONAR CATEGORIA'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            // Formas de Pagamento
            ConfigSection(
              title: 'Formas de Pagamento',
              description: 'Métodos de pagamento aceitos',
              children: [
                ...settings.paymentMethods.map((method) {
                  return ConfigItemCard(
                    item: method,
                    onDelete: () => _removeItem(
                      method,
                      _settingsService.removePaymentMethod,
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _addItem(
                    'forma de pagamento',
                    _settingsService.addPaymentMethod,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('ADICIONAR FORMA'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Botão Salvar Final
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'SALVAR TODAS AS CONFIGURAÇÕES',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
