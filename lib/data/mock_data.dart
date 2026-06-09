import 'package:quzhi_app/models/app_models.dart';

const CATEGORIES = [
  Category(key: 'all', label: '推荐', emoji: '🔥'),
  Category(key: 'history', label: '历史典故', emoji: '📜'),
  Category(key: 'celebrity', label: '名人', emoji: '⭐'),
  Category(key: 'joke', label: '笑话', emoji: '😂'),
  Category(key: 'riddle', label: '脑筋急转弯', emoji: '🧠'),
  Category(key: 'recipe', label: '菜谱', emoji: '🍳'),
  Category(key: 'health', label: '养生', emoji: '🌿'),
];

const CONTENT_ITEMS = [
  ContentItem(id: '1', category: 'history', title: '破釜沉舟：项羽的绝境反击', summary: '公元前207年，项羽率军渡漳河后，命令士兵凿沉船只、砸破锅灶...', image: 'https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?w=400&q=80', likes: 1243, views: 8920, height: 'tall'),
  ContentItem(id: '2', category: 'recipe', title: '红烧肉的秘密做法', summary: '选用五花肉，先炒糖色，加入生抽老抽，文火慢炖两小时，色泽红亮...', image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80', likes: 876, views: 5430, height: 'short'),
  ContentItem(id: '3', category: 'joke', title: '数学老师的灵魂一问', summary: '老师：同学们，1+1等于多少？小明：老师，等于你！老师：为什么？小明：因为你是unique...', image: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&q=80', likes: 3421, views: 12800, height: 'short'),
  ContentItem(id: '4', category: 'health', title: '冬季养生必喝的五种汤', summary: '天气转凉，中医建议多喝温补类汤品。黄芪红枣汤、当归羊肉汤...', image: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&q=80', likes: 654, views: 4210, height: 'tall'),
  ContentItem(id: '5', category: 'celebrity', title: '爱因斯坦为什么总穿同款衣服', summary: '据说爱因斯坦有多套完全相同的西装。他认为每天花时间思考穿什么是在浪费大脑...', image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80', likes: 2156, views: 9870, height: 'tall'),
  ContentItem(id: '6', category: 'riddle', title: '什么东西越洗越脏？', summary: '答案是：水！你洗东西，水就变脏了。这道脑筋急转弯考验你的反向思维...', image: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&q=80', likes: 445, views: 3200, height: 'short'),
  ContentItem(id: '7', category: 'history', title: '草船借箭的历史真相', summary: '三国演义中诸葛亮草船借箭的故事家喻户晓，但历史上这件事其实另有其人...', image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80', likes: 1876, views: 11200, height: 'short'),
  ContentItem(id: '8', category: 'recipe', title: '麻婆豆腐正宗做法详解', summary: '四川麻婆豆腐讲究麻、辣、烫、鲜。豆腐要用嫩豆腐，牛肉末要炒香...', image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80', likes: 987, views: 6540, height: 'tall'),
  ContentItem(id: '9', category: 'health', title: '每天走路8000步的惊人效果', summary: '最新研究表明，每天走路8000步可以显著降低心血管疾病风险、改善睡眠质量...', image: 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&q=80', likes: 3210, views: 15600, height: 'short'),
  ContentItem(id: '10', category: 'celebrity', title: '乔布斯的最后一课：简单的力量', summary: '乔布斯临终前说：我用了一辈子，才学会了简单。真正的创新不是加法，而是减法...', image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80', likes: 5432, views: 23100, height: 'tall'),
  ContentItem(id: '11', category: 'joke', title: '程序员和产品经理的故事', summary: '产品经理：我想要一个功能，用户点击之后…程序员：先停一下，你确定用户会找到那个按钮吗？', image: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&q=80', likes: 2876, views: 13400, height: 'short'),
  ContentItem(id: '12', category: 'riddle', title: '没有脚却能跑的是什么？', summary: '答案是：时间！时间无法停止，不断向前，却从来没有脚...', image: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&q=80', likes: 678, views: 4300, height: 'short'),
  ContentItem(id: '13', category: 'history', title: '丝绸之路的黄金岁月', summary: '汉武帝派张骞出使西域，开辟了连接东西方的贸易通道。丝绸、瓷器、茶叶...', image: 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=400&q=80', likes: 1543, views: 8760, height: 'tall'),
  ContentItem(id: '14', category: 'recipe', title: '宫保鸡丁的由来与做法', summary: '宫保鸡丁由清朝四川总督丁宝桢发明，因其官职"宫保"而得名。鸡丁要嫩滑...', image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80', likes: 1234, views: 7890, height: 'short'),
  ContentItem(id: '15', category: 'health', title: '失眠？试试这6个中医小妙招', summary: '中医认为失眠多因心神不宁、肝火旺盛。睡前泡脚、按摩涌泉穴、喝酸枣仁茶...', image: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&q=80', likes: 4321, views: 19800, height: 'tall'),
  ContentItem(id: '16', category: 'celebrity', title: '鲁迅为什么弃医从文', summary: '1906年，鲁迅在看幻灯片时，看到麻木的中国人围观同胞被砍头，深受刺激...', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80', likes: 2345, views: 10500, height: 'short'),
];

const MALL_PRODUCTS = [
  MallProduct(id: 'p1', name: '保温杯 500ml', points: 3000, image: 'https://images.unsplash.com/photo-1544892246-5e4e02ef5cb0?w=300&q=80', tag: '热门', stock: 99),
  MallProduct(id: 'p2', name: '蓝牙耳机', points: 8000, image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&q=80', tag: '新品', stock: 50),
  MallProduct(id: 'p3', name: '京东购物卡 50元', points: 5000, image: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=300&q=80', tag: '限量', stock: 20),
  MallProduct(id: 'p4', name: '话费充值 10元', points: 1000, image: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=300&q=80', stock: 999),
  MallProduct(id: 'p5', name: '智能手环', points: 12000, image: 'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=300&q=80', tag: '精品', stock: 30),
  MallProduct(id: 'p6', name: '有机茶叶礼盒', points: 2500, image: 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=300&q=80', stock: 80),
  MallProduct(id: 'p7', name: '手机壳（定制）', points: 800, image: 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?w=300&q=80', stock: 200),
  MallProduct(id: 'p8', name: '移动电源 20000mAh', points: 6000, image: 'https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?w=300&q=80', tag: '爆款', stock: 45),
];

const NOTIFICATIONS = [
  AppNotification(id: '1', type: 'points', title: '积分到账', body: '您观看了一个激励广告，获得 +500 积分', time: '刚刚', points: 500),
  AppNotification(id: '2', type: 'invite', title: '好友接受邀请', body: '您邀请的好友「小红薯」已注册成功，双方各获得 500 积分', time: '5分钟前', points: 500),
  AppNotification(id: '3', type: 'reward', title: '积分奖励', body: '连续签到7天奖励已发放，+200 积分', time: '1小时前', points: 200),
  AppNotification(id: '4', type: 'achievement', title: '解锁成就「阅读达人」', body: '恭喜！累计阅读文章100篇，获得专属徽章', time: '昨天 18:22', read: true),
  AppNotification(id: '5', type: 'system', title: '系统通知', body: '您的账号已通过实名认证，享受更多专属权益', time: '昨天 12:00', read: true),
  AppNotification(id: '6', type: 'invite', title: '好友接受邀请', body: '您邀请的好友「天天向上」已注册成功，双方各获得 500 积分', time: '2天前', read: true, points: 500),
  AppNotification(id: '7', type: 'points', title: '积分到账', body: '您浏览了一个横幅广告，获得 +10 积分', time: '2天前', read: true, points: 10),
  AppNotification(id: '8', type: 'system', title: '活动预告', body: '【双十一特惠】积分翻倍活动即将开启，敬请期待！', time: '3天前', read: true),
  AppNotification(id: '9', type: 'reward', title: '首次注册奖励', body: '感谢您注册趣知App，送您 200 积分作为开门红！', time: '7天前', read: true, points: 200),
];

const MOCK_ADDRESSES = [
  Address(id: '1', name: '张三', phone: '138****5678', province: '广东省', city: '深圳市', district: '南山区', detail: '科技园南路18号', isDefault: true),
  Address(id: '2', name: '李四', phone: '139****1234', province: '北京市', city: '北京市', district: '朝阳区', detail: '望京SOHO T2-1001', isDefault: false),
];

const DETAIL_CONTENT = {
  '1': '''公元前207年，项羽率楚军渡过漳河，准备与秦军主力决战。渡河之后，他下令士兵凿沉所有船只，砸破所有锅灶，每人只携带三天的口粮，以此表明有进无退、决战到底的决心。

面对这种绝境，楚军士兵人人以一当十，在九次大战中全部获胜，彻底击败了秦军主力，创造了以少胜多的经典战例。

"破釜沉舟"这个成语由此而来，比喻做事下定决心，不留后路，义无反顾地去完成目标。

◆ 历史点评

项羽的这一策略表面上看是冒险，实际上是对人性的深刻洞察——当人无路可退时，潜能将被彻底激发。现代心理学称之为"背水一战效应"，当选择被消除，人的专注度和战斗力会成倍提升。''',
  '2': '''一道正宗的红烧肉，关键在于三个步骤：炒糖色、小火慢炖、收汁上色。

【材料】五花肉 500g、冰糖 30g、生抽 2勺、老抽 1勺、料酒 2勺、姜片、八角、桂皮

【步骤】

① 五花肉切 4cm 大块，冷水下锅焯水，去除血沫后捞出备用。

② 锅中放少量油，加入冰糖，小火不停翻炒，待冰糖化开变成棕红色时，立即放入五花肉翻炒上色。

③ 加入料酒、生抽、老抽、姜片、八角、桂皮，加热水至刚好没过肉。

④ 大火烧开后转最小火，加盖焖炖 90 分钟。

⑤ 开盖大火收汁，至汤汁浓稠、色泽红亮即可。

◆ 小贴士

糖色是关键，颜色太浅不香，颜色太深会苦。建议用冰糖而非白砂糖，成品颜色更透亮。''',
};

const CATEGORY_COLORS = {
  'history': {'bg': 0xFFFDE68A, 'text': 0xFF92400E, 'dot': 0xFFF59E0B},
  'celebrity': {'bg': 0xFFBFDBFE, 'text': 0xFF1E40AF, 'dot': 0xFF3B82F6},
  'joke': {'bg': 0xFFFEF08A, 'text': 0xFF854D0E, 'dot': 0xFFEAB308},
  'riddle': {'bg': 0xFFE9D5FF, 'text': 0xFF6B21A8, 'dot': 0xFFA855F7},
  'recipe': {'bg': 0xFFFECACA, 'text': 0xFF991B1B, 'dot': 0xFFEF4444},
  'health': {'bg': 0xFFBBF7D0, 'text': 0xFF166534, 'dot': 0xFF22C55E},
  'all': {'bg': 0xFFF3F4F6, 'text': 0xFF374151, 'dot': 0xFF9CA3AF},
};

const CATEGORY_LABELS = {
  'history': '历史典故',
  'celebrity': '名人',
  'joke': '笑话',
  'riddle': '脑筋急转弯',
  'recipe': '菜谱',
  'health': '养生',
};

const RECENT_SEARCHES = ['科技', '财经', '减肥食谱', '旅游攻略', '宠物', '汽车评测'];
const MALL_FILTERS = ['全部', '热门', '新品', '限量', '精品'];
const PROVINCES = ['广东省', '北京市', '上海市', '浙江省', '江苏省', '四川省', '湖北省', '湖南省', '河南省', '山东省'];
