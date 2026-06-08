import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = List.from(MOCK_ADDRESSES);
  List<Address> get addresses => _addresses;

  void addAddress(Address addr) {
    final list = List<Address>.from(_addresses);
    if (addr.isDefault) {
      list.forEach((a) {
        // clear all defaults
      });
    }
    list.add(addr);
    _addresses = list;
    notifyListeners();
  }

  void updateAddress(Address addr) {
    _addresses = _addresses.map((a) => a.id == addr.id ? addr : a).toList();
    notifyListeners();
  }

  void deleteAddress(String id) {
    _addresses = _addresses.where((a) => a.id != id).toList();
    notifyListeners();
  }

  void setDefault(String id) {
    _addresses = _addresses.map((a) => a.copyWith(isDefault: a.id == id)).toList();
    notifyListeners();
  }
}
