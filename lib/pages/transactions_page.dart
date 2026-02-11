import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/services/settings_service.dart';
import '../core/widgets/responsive_layout.dart'; // ← ADICIONAR ESTA LINHA
import '../features/transactions/models/transaction_model.dart';
import '../features/transactions/widgets/transaction_card.dart';
import '../features/transactions/widgets/summary_card.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _settingsService = SettingsService();
  String _selectedPeriod = 'month';
  String _selectedType = 'all';

  // Mock data
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      type: 'receita',
      amount: 2100.00,
      description: 'Tatuagem Colorida - Maria Silva',
      category: 'Serviço',
      paymentMethod: 'PIX',
      date: '2026-02-10',
      artistId: 2,
      appointmentId: 1,
      studioAmount: 630.00,
      artistAmount: 1470.00,
    ),
    Transaction(
      id: '2',
      type: 'receita',
      amount: 1400.00,
      description: 'Tatuagem P&B - João Santos',
      category: 'Serviço',
      paymentMethod: 'Dinheiro',
      date: '2026-02-10',
      artistId: 3,
      appointmentId: 2,
      studioAmount: 490.00,
      artistAmount: 910.00,
    ),
    Transaction(
      id: '3',
      type: 'despesa',
      amount: 250.00,
      description: 'Compra de tintas coloridas',
      category: 'Material',
      paymentMethod: 'Cartão',
      date: '2026-02-09',
      artistId: null,
    ),
    Transaction(
      id: '4',
      type: 'despesa',
      amount: 800.00,
      description: 'Aluguel do estúdio',
      category: 'Aluguel',
      paymentMethod: 'Transferência',
      date: '2026-02-05',
      artistId: null,
    ),
    Transaction(
      id: '5',
      type: 'receita',
      amount: 500.00,
      description: 'Retoque - Carla Mendes',
      category: 'Serviço',
      paymentMethod: 'PIX',
      date: '2026-02-09',
      artistId: 2,
      appointmentId: 5,
      studioAmount: 150.00,
      artistAmount: 350.00,
    ),
  ];

  List<Transaction> get _filteredTransactions {
    var filtered = _transactions;
    if (_selectedType != 'all') {
      filtered = filtered.where((t) => t.type == _selectedType).toList();
    }
    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  Map<String, double> get _summary {
    final revenues = _transactions
        .where((t) => t.isRevenue)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final studioTotal = _transactions
        .where((t) => t.isRevenue && t.studioAmount != null)
        .fold(0.0, (sum, t) => sum + t.studioAmount!);
    final artistsTotal = _transactions
        .where((t) => t.isRevenue && t.artistAmount != null)
        .fold(0.0, (sum, t) => sum + t.artistAmount!);

    return {
      'revenues': revenues,
      'expenses': expenses,
      'profit': revenues - expenses,
      'studioTotal': studioTotal,
      'artistsTotal': artistsTotal,
    };
  }

  String _getArtistName(int artistId) {
    switch (artistId) {
      case 2:
        return 'Maria Santos';
      case 3:
        return 'Pedro Costa';
      default:
        return 'Desconhecido';
    }
  }

  void _showTransactionForm({Transaction? transaction}) {
    String? selectedType = transaction?.type ?? 'receita';
    String? selectedCategory = transaction?.category ??
        (_settingsService.financialCategories.isNotEmpty
            ? _settingsService.financialCategories.first
            : null);
    String? selectedPaymentMethod = transaction?.paymentMethod ??
        (_settingsService.paymentMethods.isNotEmpty
            ? _settingsService.paymentMethods.first
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
              transaction == null ? 'NOVO LANÇAMENTO' : 'EDITAR LANÇAMENTO',
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
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'TIPO'),
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(
                            value: 'receita', child: Text('Receita')),
                        DropdownMenuItem(
                            value: 'despesa', child: Text('Despesa')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'VALOR (R\$)',
                        hintText: '500.00',
                      ),
                      controller: TextEditingController(
                        text: transaction?.amount.toString(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'DESCRIÇÃO',
                        hintText: 'Ex: Compra de material',
                      ),
                      controller: TextEditingController(
                        text: transaction?.description,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // DROPDOWN CATEGORIA - INTEGRADO
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'CATEGORIA'),
                      value: selectedCategory,
                      items: _settingsService.financialCategories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // DROPDOWN PAGAMENTO - INTEGRADO
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          labelText: 'FORMA DE PAGAMENTO'),
                      value: selectedPaymentMethod,
                      items: _settingsService.paymentMethods.map((method) {
                        return DropdownMenuItem(
                            value: method, child: Text(method));
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedPaymentMethod = value;
                        });
                      },
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
                        transaction == null
                            ? 'Lançamento adicionado!'
                            : 'Lançamento atualizado!',
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

  void _deleteTransaction(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.error, width: 1),
        ),
        title: const Text(
          'EXCLUIR LANÇAMENTO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Deseja realmente excluir "${transaction.description}"?',
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
                _transactions.remove(transaction);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lançamento excluído!'),
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
    final summary = _summary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveLayout.getHorizontalPadding(context)),
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
                      'FINANCEIRO',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Controle completo de receitas e despesas',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showTransactionForm(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('LANÇAMENTO'),
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

            // Summary Cards - RESPONSIVO
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: ResponsiveLayout.getGridCrossAxisCount(
                context,
                mobile: 1,
                tablet: 2,
                desktop: 5,
              ),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: ResponsiveLayout.isMobile(context) ? 2.0 : 1.3,
              children: [
                SummaryCard(
                  label: 'Receita Total',
                  value: summary['revenues']!,
                  color: AppColors.success,
                  icon: Icons.arrow_downward,
                  trend: 'Este mês',
                ),
                SummaryCard(
                  label: 'Despesas',
                  value: summary['expenses']!,
                  color: AppColors.error,
                  icon: Icons.arrow_upward,
                  trend: 'Este mês',
                ),
                SummaryCard(
                  label: 'Lucro',
                  value: summary['profit']!,
                  color: const Color(0xFF3b82f6),
                  icon: Icons.trending_up,
                  trend: summary['profit']! > 0 ? 'Positivo' : 'Negativo',
                ),
                SummaryCard(
                  label: 'Receita Estúdio',
                  value: summary['studioTotal']!,
                  color: AppColors.success,
                  icon: Icons.store,
                  trend: 'Após splits',
                ),
                SummaryCard(
                  label: 'Pago Tatuadores',
                  value: summary['artistsTotal']!,
                  color: AppColors.primary,
                  icon: Icons.people,
                  trend: 'Comissões',
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Filters
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border, width: 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    children: [
                      _buildFilterButton('TODOS', 'all'),
                      _buildFilterButton('RECEITAS', 'receita'),
                      _buildFilterButton('DESPESAS', 'despesa'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Transactions List
            if (_filteredTransactions.isEmpty)
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
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma transação encontrada',
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
              ..._filteredTransactions.map((transaction) {
                return TransactionCard(
                  transaction: transaction,
                  artistName: transaction.artistId != null
                      ? _getArtistName(transaction.artistId!)
                      : null,
                  onDelete: () => _deleteTransaction(transaction),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isActive = _selectedType == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = value;
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
