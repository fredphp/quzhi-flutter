import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/providers/address_provider.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  final VoidCallback onBack;

  const AddressPage({super.key, required this.onBack});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool _showForm = false;
  String? _editingId;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _detailController = TextEditingController();
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Load addresses when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses();
    });
  }

  void _openAdd() {
    _editingId = null;
    _nameController.clear();
    _phoneController.clear();
    _provinceController.clear();
    _cityController.clear();
    _districtController.clear();
    _detailController.clear();
    _isDefault = false;
    setState(() => _showForm = true);
  }

  void _openEdit(Address addr) {
    _editingId = addr.id;
    _nameController.text = addr.name;
    _phoneController.text = addr.phone;
    _provinceController.text = addr.province;
    _cityController.text = addr.city;
    _districtController.text = addr.district;
    _detailController.text = addr.detail;
    _isDefault = addr.isDefault;
    setState(() => _showForm = true);
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _detailController.text.isEmpty) return;
    setState(() => _isSaving = true);
    final provider = context.read<AddressProvider>();
    final addr = Address(
      id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      phone: _phoneController.text,
      province: _provinceController.text,
      city: _cityController.text,
      district: _districtController.text,
      detail: _detailController.text,
      isDefault: _isDefault,
    );
    bool success;
    if (_editingId != null) {
      success = await provider.updateAddress(addr);
    } else {
      success = await provider.addAddress(addr);
    }
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      if (success) _showForm = false;
    });
    if (!success && mounted) {
      final msg = provider.errorMessage ?? '保存失败，请重试';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final addresses = addressProvider.addresses;

    return Stack(
      children: [
        Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('收货地址',
                        style: TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                  GestureDetector(
                    onTap: _openAdd,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text('新增',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Address list
            Expanded(
              child: addressProvider.isLoading && addresses.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => addressProvider.loadAddresses(),
                      child: addresses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map, size: 64, color: Colors.grey.withOpacity(0.3)),
                                  const SizedBox(height: 16),
                                  Text('暂无收货地址', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _openAdd,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.brand,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    ),
                                    child: const Text('添加地址'),
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: addresses.map((addr) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: AppTheme.cardDecoration(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(addr.name,
                                                style: const TextStyle(fontWeight: FontWeight.w700)),
                                            const SizedBox(width: 8),
                                            Text(addr.phone,
                                                style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                                            if (addr.isDefault) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  gradient: AppTheme.brandGradient,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Text('默认',
                                                    style: TextStyle(color: Colors.white, fontSize: 10)),
                                              ),
                                            ],
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                await context.read<AddressProvider>().deleteAddress(addr.id);
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF5F5F5),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Icon(Icons.delete, size: 16, color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text('${addr.province} ${addr.city} ${addr.district} ${addr.detail}',
                                            style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.4)),
                                        const SizedBox(height: 12),
                                        const Divider(height: 1),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => context.read<AddressProvider>().setDefault(addr.id),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: addr.isDefault ? AppTheme.brand : Colors.grey[300]!,
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: addr.isDefault ? const Color(0xFFFFF3E0) : null,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.check, size: 12, color: addr.isDefault ? AppTheme.brand : Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Text(addr.isDefault ? '已设默认' : '设为默认',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                            color: addr.isDefault ? AppTheme.brand : Colors.grey)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () => _openEdit(addr),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey[300]!),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text('编辑',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey[500])),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
            ),
          ],
        ),

        // Edit form overlay
        if (_showForm) _buildForm(),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showForm = false),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(_editingId != null ? '编辑地址' : '新增地址',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _FormInput(label: '收货人姓名', controller: _nameController, placeholder: '请输入姓名'),
                _FormInput(label: '手机号码', controller: _phoneController, placeholder: '请输入手机号', keyboardType: TextInputType.phone),
                Row(
                  children: [
                    Expanded(child: _FormInput(label: '省份', controller: _provinceController, placeholder: '请选择省份')),
                    const SizedBox(width: 8),
                    Expanded(child: _FormInput(label: '城市', controller: _cityController, placeholder: '请输入城市')),
                  ],
                ),
                _FormInput(label: '区/县', controller: _districtController, placeholder: '请输入区/县'),
                _FormInput(label: '详细地址', controller: _detailController, placeholder: '街道、楼栋、门牌号'),
                // Default switch
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.cardDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('设为默认地址', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      Switch(
                        value: _isDefault,
                        onChanged: (v) => setState(() => _isDefault = v),
                        activeColor: AppTheme.brand,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('保存地址', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;

  const _FormInput({
    required this.label,
    required this.controller,
    required this.placeholder,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
