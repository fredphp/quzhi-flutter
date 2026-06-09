import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';
import 'package:quzhi_app/api/api_service.dart';
import 'package:quzhi_app/utils/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _step = 'phone';
  String _phone = '';
  String _code = '';
  int _countdown = 0;
  bool _agreed = false;
  bool _loading = false;
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var c in _codeControllers) {
      c.dispose();
    }
    for (var f in _codeFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _isPhoneValid => RegExp(r'^1[3-9]\d{9}$').hasMatch(_phone);

  void _startCountdown() {
    setState(() => _countdown = 60);
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _countdown--;
      });
      return _countdown > 0;
    });
  }

  Future<void> _sendCode() async {
    if (!_isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的手机号')),
      );
      return;
    }
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先阅读并同意用户协议')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ApiService.sendSms(mobile: _phone);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _step = 'code';
      });
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('验证码已发送至 ${_phone.substring(0, 3)}****${_phone.substring(7)}')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      final msg = e.toString().replaceAll('ApiException(', '').replaceAll('): ', ': ').replaceAll(')', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg.isNotEmpty ? msg : '发送验证码失败，请稍后重试')),
      );
    }
  }

  Future<void> _verify() async {
    String code = _codeControllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入完整的验证码')),
      );
      return;
    }
    setState(() => _loading = true);
    final success = await context.read<AppProvider>().login(_phone, code);
    if (!mounted) return;
    setState(() => _loading = false);
    if (success) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      final error = context.read<AppProvider>().errorMessage ?? '登录失败，请重试';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: AppTheme.cardDecoration(),
                  padding: const EdgeInsets.all(24),
                  child: _step == 'phone' ? _buildPhoneStep() : _buildCodeStep(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  Text(
                    '登录即可获得新人奖励积分 +200',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['微信登录', 'QQ登录', 'Apple登录']
                        .map((m) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(m,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[400])),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 64, bottom: 48, left: 24, right: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFFA726), Color(0xFFFFD166)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -48,
            top: -48,
            child: Container(
              width: 208,
              height: 208,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 32,
            top: 80,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Text('趣',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 16),
              const Text('趣知',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(
                _step == 'phone' ? '手机号一键登录，每天赚积分' : '输入手机验证码',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('登录 / 注册',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('未注册手机号将自动创建账号',
            style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text('+86', style: TextStyle(fontWeight: FontWeight.w500)),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 1,
                  height: 24,
                  color: Colors.grey[300]),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  onChanged: (v) => setState(() => _phone = v.replaceAll(RegExp(r'\D'), '')),
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: '请输入手机号',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (_phone.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _phone = ''),
                  child: Icon(Icons.cancel, size: 16, color: Colors.grey[400]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _agreed = !_agreed),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _agreed ? AppTheme.brand : Colors.transparent,
                  border: Border.all(
                    color: _agreed ? AppTheme.brand : Colors.grey,
                    width: 2,
                  ),
                ),
                child: _agreed
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '我已阅读并同意 ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    children: [
                      TextSpan(
                          text: '《用户服务协议》',
                          style: const TextStyle(
                              color: AppTheme.brand,
                              fontWeight: FontWeight.w500)),
                      const TextSpan(text: ' 和 '),
                      TextSpan(
                          text: '《隐私政策》',
                          style: const TextStyle(
                              color: AppTheme.brand,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (_isPhoneValid && !_loading) ? _sendCode : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brand,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppTheme.brand.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('获取验证码',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _step = 'phone';
            for (var c in _codeControllers) {
              c.clear();
            }
          }),
          child: Row(
            children: [
              const Icon(Icons.arrow_back, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text('返回修改号码',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('输入验证码',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: '已发送至 ',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            children: [
              TextSpan(
                text:
                    '${_phone.substring(0, 3)}****${_phone.substring(7)}',
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (idx) => SizedBox(
              width: 44,
              height: 56,
              child: TextField(
                controller: _codeControllers[idx],
                focusNode: _codeFocusNodes[idx],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppTheme.brand, width: 2),
                  ),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && idx < 5) {
                    _codeFocusNodes[idx + 1].requestFocus();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: _countdown > 0
              ? Text.rich(
                  TextSpan(
                    text: '重新发送 ',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    children: [
                      TextSpan(
                        text: '$_countdown s',
                        style: const TextStyle(
                            color: AppTheme.brand,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: _sendCode,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.refresh, size: 14, color: AppTheme.brand),
                      const SizedBox(width: 4),
                      const Text('重新发送验证码',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.brand,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (!_loading &&
                    _codeControllers.every((c) => c.text.isNotEmpty))
                ? _verify
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brand,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppTheme.brand.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('立即登录',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
