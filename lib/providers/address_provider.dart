import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/api/api_service.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  List<Address> get addresses => _addresses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Load addresses from API
  Future<void> loadAddresses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.getAddressList();
      final data = result['data'] as Map<String, dynamic>? ?? result;
      final list = data['list'] as List<dynamic>? ?? data['rows'] as List<dynamic>? ?? [];
      _addresses = list.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Add address via API, then reload
  Future<bool> addAddress(Address addr) async {
    try {
      await ApiService.addAddress(
        name: addr.name,
        phone: addr.phone,
        province: addr.province,
        city: addr.city,
        district: addr.district,
        detail: addr.detail,
        isDefault: addr.isDefault,
      );
      await loadAddresses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update address via API, then reload
  Future<bool> updateAddress(Address addr) async {
    try {
      await ApiService.updateAddress(
        id: int.tryParse(addr.id) ?? 0,
        name: addr.name,
        phone: addr.phone,
        province: addr.province,
        city: addr.city,
        district: addr.district,
        detail: addr.detail,
        isDefault: addr.isDefault,
      );
      await loadAddresses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete address via API, then reload
  Future<void> deleteAddress(String id) async {
    try {
      await ApiService.deleteAddress(id: int.tryParse(id) ?? 0);
      await loadAddresses();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Set default address via API, then reload
  Future<void> setDefault(String id) async {
    try {
      await ApiService.setDefaultAddress(id: int.tryParse(id) ?? 0);
      await loadAddresses();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
