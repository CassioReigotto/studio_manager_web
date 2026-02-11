import 'package:flutter/foundation.dart';
import '../../features/settings/models/settings_model.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  StudioSettings _settings = StudioSettings.defaults();

  StudioSettings get settings => _settings;

  // Getters para acesso rápido
  List<String> get serviceCategories => _settings.serviceCategories;
  List<String> get inventoryCategories => _settings.inventoryCategories;
  List<String> get measurementUnits => _settings.measurementUnits;
  List<String> get financialCategories => _settings.financialCategories;
  List<String> get paymentMethods => _settings.paymentMethods;
  String get studioName => _settings.studioName;

  // Inicializar (futuramente vai carregar do backend/storage)
  Future<void> initialize() async {
    // Por enquanto usa defaults
    // Futuramente: _settings = await loadFromStorage();
    _settings = StudioSettings.defaults();
    notifyListeners();
  }

  // Atualizar settings
  void updateSettings(StudioSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
    // Futuramente: saveToStorage(_settings);
  }

  // Adicionar categoria de serviço
  void addServiceCategory(String category) {
    if (!_settings.serviceCategories.contains(category)) {
      _settings = _settings.copyWith(
        serviceCategories: [..._settings.serviceCategories, category],
      );
      notifyListeners();
    }
  }

  // Remover categoria de serviço
  void removeServiceCategory(String category) {
    final updated =
        _settings.serviceCategories.where((c) => c != category).toList();
    _settings = _settings.copyWith(serviceCategories: updated);
    notifyListeners();
  }

  // Adicionar categoria de estoque
  void addInventoryCategory(String category) {
    if (!_settings.inventoryCategories.contains(category)) {
      _settings = _settings.copyWith(
        inventoryCategories: [..._settings.inventoryCategories, category],
      );
      notifyListeners();
    }
  }

  // Remover categoria de estoque
  void removeInventoryCategory(String category) {
    final updated =
        _settings.inventoryCategories.where((c) => c != category).toList();
    _settings = _settings.copyWith(inventoryCategories: updated);
    notifyListeners();
  }

  // Adicionar unidade de medida
  void addMeasurementUnit(String unit) {
    if (!_settings.measurementUnits.contains(unit)) {
      _settings = _settings.copyWith(
        measurementUnits: [..._settings.measurementUnits, unit],
      );
      notifyListeners();
    }
  }

  // Remover unidade de medida
  void removeMeasurementUnit(String unit) {
    final updated = _settings.measurementUnits.where((u) => u != unit).toList();
    _settings = _settings.copyWith(measurementUnits: updated);
    notifyListeners();
  }

  // Adicionar categoria financeira
  void addFinancialCategory(String category) {
    if (!_settings.financialCategories.contains(category)) {
      _settings = _settings.copyWith(
        financialCategories: [..._settings.financialCategories, category],
      );
      notifyListeners();
    }
  }

  // Remover categoria financeira
  void removeFinancialCategory(String category) {
    final updated =
        _settings.financialCategories.where((c) => c != category).toList();
    _settings = _settings.copyWith(financialCategories: updated);
    notifyListeners();
  }

  // Adicionar forma de pagamento
  void addPaymentMethod(String method) {
    if (!_settings.paymentMethods.contains(method)) {
      _settings = _settings.copyWith(
        paymentMethods: [..._settings.paymentMethods, method],
      );
      notifyListeners();
    }
  }

  // Remover forma de pagamento
  void removePaymentMethod(String method) {
    final updated = _settings.paymentMethods.where((m) => m != method).toList();
    _settings = _settings.copyWith(paymentMethods: updated);
    notifyListeners();
  }

  // Atualizar informações do estúdio
  void updateStudioInfo({
    String? studioName,
    String? address,
    String? phone,
    String? email,
  }) {
    _settings = _settings.copyWith(
      studioName: studioName,
      address: address,
      phone: phone,
      email: email,
    );
    notifyListeners();
  }
}
