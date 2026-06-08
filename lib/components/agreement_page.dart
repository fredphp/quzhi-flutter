import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class AgreementPage extends StatelessWidget {
  final String type;
  final VoidCallback onBack;

  const AgreementPage({
    super.key,
    required this.type,
    required this.onBack,
  });

  static const _content = {
    'privacy': {
      'title': '用户隐私协议',
      'body': [
        '一、信息收集',
        '我们收集您提供的注册信息（手机号、昵称、收货地址等），以及您使用本App过程中产生的行为数据（浏览记录、积分变动、广告交互等），用于提供服务、改善体验及广告投放优化。',
        '二、信息使用',
        '您的个人信息仅用于提供趣知App各项功能，包括积分奖励结算、商品兑换配送、推广邀请统计等。未经您的明确同意，我们不会将您的个人信息共享给第三方。',
        '三、信息存储与保护',
        '您的个人信息存储在中国境内的服务器中，我们采用行业标准的加密技术和安全措施保护您的信息安全。',
        '四、Cookie与广告',
        '本App使用第三方广告SDK，可能收集设备标识符、广告交互数据，用于精准广告投放。您可在设置中选择关闭个性化广告。',
        '五、您的权利',
        '您有权查阅、更正、删除您的个人信息，或注销账号。请通过App内「意见反馈」联系我们，我们将在15个工作日内响应。',
        '六、未成年人保护',
        '本App不面向14周岁以下未成年人提供服务。',
      ],
    },
    'terms': {
      'title': '用户服务协议',
      'body': [
        '一、服务条款',
        '欢迎使用趣知App。使用本应用即表示您同意遵守以下条款。趣知App提供内容阅读、积分奖励、商品兑换等服务。',
        '二、用户账号',
        '用户须通过手机号注册账号，并对账号安全负责。禁止转让、出售账号。',
        '三、积分规则',
        '积分通过阅读文章、观看广告、邀请好友等途径获取。积分不可兑换现金，有效期为永久。平台有权调整积分获取规则。',
        '四、内容规范',
        '用户不得发布违法、违规、侵权内容。平台有权删除违规内容并封禁账号。',
        '五、免责声明',
        '本App提供的广告内容由第三方提供，平台不对广告内容真实性负责。因不可抗力导致服务中断，平台不承担责任。',
        '六、协议修改',
        '平台有权随时修改本协议，修改后的协议在App内公示后生效。',
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final data = _content[type] ?? _content['privacy']!;

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
                  onTap: onBack,
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
                Text(data['title'] as String,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: (data['body'] as List<String>).map((paragraph) {
                final isHeading = paragraph.startsWith('一、') ||
                    paragraph.startsWith('二、') ||
                    paragraph.startsWith('三、') ||
                    paragraph.startsWith('四、') ||
                    paragraph.startsWith('五、') ||
                    paragraph.startsWith('六、');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    paragraph,
                    style: TextStyle(
                      fontSize: isHeading ? 16 : 14,
                      fontWeight: isHeading ? FontWeight.w800 : FontWeight.normal,
                      height: 1.6,
                      color: isHeading ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
