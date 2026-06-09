/// Tab key enum for bottom navigation
enum TabKey { home, mall, promote, mine }

/// Content item model
class ContentItem {
  final String id;
  final String category;
  final String title;
  final String summary;
  final String image;
  final int likes;
  final int views;
  final String? height;
  final String? body;
  final bool isLiked;
  final bool isBookmarked;
  final int? categoryId;

  const ContentItem({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.image,
    required this.likes,
    required this.views,
    this.height,
    this.body,
    this.isLiked = false,
    this.isBookmarked = false,
    this.categoryId,
  });

  ContentItem copyWith({
    String? id,
    String? category,
    String? title,
    String? summary,
    String? image,
    int? likes,
    int? views,
    String? height,
    String? body,
    bool? isLiked,
    bool? isBookmarked,
    int? categoryId,
  }) {
    return ContentItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      height: height ?? this.height,
      body: body ?? this.body,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: (json['id'] ?? '').toString(),
      category: json['category'] ?? json['category_name'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? json['description'] ?? '',
      image: json['image'] ?? json['cover'] ?? '',
      likes: json['likes'] ?? json['like_count'] ?? 0,
      views: json['views'] ?? json['view_count'] ?? 0,
      height: json['height']?.toString(),
      body: json['body'] ?? json['content'],
      isLiked: json['is_liked'] ?? json['isLiked'] ?? false,
      isBookmarked: json['is_bookmarked'] ?? json['isBookmarked'] ?? false,
      categoryId: json['category_id'] ?? json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'summary': summary,
      'image': image,
      'likes': likes,
      'views': views,
      'height': height,
      'body': body,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'category_id': categoryId,
    };
  }
}

/// Mall product model
class MallProduct {
  final String id;
  final String name;
  final int points;
  final String image;
  final String? tag;
  final int stock;
  final int? categoryId;
  final String? description;
  final int sales;

  const MallProduct({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
    this.tag,
    required this.stock,
    this.categoryId,
    this.description,
    this.sales = 0,
  });

  MallProduct copyWith({
    String? id,
    String? name,
    int? points,
    String? image,
    String? tag,
    int? stock,
    int? categoryId,
    String? description,
    int? sales,
  }) {
    return MallProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
      image: image ?? this.image,
      tag: tag ?? this.tag,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      sales: sales ?? this.sales,
    );
  }

  factory MallProduct.fromJson(Map<String, dynamic> json) {
    return MallProduct(
      id: (json['id'] ?? '').toString(),
      name: json['name'] ?? json['title'] ?? '',
      points: json['points'] ?? json['coin'] ?? json['price'] ?? 0,
      image: json['image'] ?? json['cover'] ?? '',
      tag: json['tag'] ?? json['label'],
      stock: json['stock'] ?? json['nums'] ?? 0,
      categoryId: json['category_id'] ?? json['categoryId'],
      description: json['description'] ?? json['desc'],
      sales: json['sales'] ?? json['sale_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'points': points,
      'image': image,
      'tag': tag,
      'stock': stock,
      'category_id': categoryId,
      'description': description,
      'sales': sales,
    };
  }
}

/// Ad state model
class AdState {
  final int interstitialCount;
  final int rewardCount;
  final int lastInterstitialTime;
  final int lastRewardTime;
  final int lastBannerTime;

  const AdState({
    this.interstitialCount = 0,
    this.rewardCount = 10,
    this.lastInterstitialTime = 0,
    this.lastRewardTime = 0,
    this.lastBannerTime = 0,
  });

  AdState copyWith({
    int? interstitialCount,
    int? rewardCount,
    int? lastInterstitialTime,
    int? lastRewardTime,
    int? lastBannerTime,
  }) {
    return AdState(
      interstitialCount: interstitialCount ?? this.interstitialCount,
      rewardCount: rewardCount ?? this.rewardCount,
      lastInterstitialTime: lastInterstitialTime ?? this.lastInterstitialTime,
      lastRewardTime: lastRewardTime ?? this.lastRewardTime,
      lastBannerTime: lastBannerTime ?? this.lastBannerTime,
    );
  }

  factory AdState.fromJson(Map<String, dynamic> json) {
    return AdState(
      interstitialCount: json['interstitialCount'] ?? json['interstitial_count'] ?? 0,
      rewardCount: json['rewardCount'] ?? json['reward_count'] ?? 10,
      lastInterstitialTime: json['lastInterstitialTime'] ?? json['last_interstitial_time'] ?? 0,
      lastRewardTime: json['lastRewardTime'] ?? json['last_reward_time'] ?? 0,
      lastBannerTime: json['lastBannerTime'] ?? json['last_banner_time'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interstitialCount': interstitialCount,
      'rewardCount': rewardCount,
      'lastInterstitialTime': lastInterstitialTime,
      'lastRewardTime': lastRewardTime,
      'lastBannerTime': lastBannerTime,
    };
  }
}

/// User state model
class UserState {
  final int points;
  final String uid;
  final String nickname;
  final String avatar;
  final String inviteCode;
  final int inviteCount;
  final int todayEarned;
  final String? token;

  const UserState({
    this.points = 0,
    this.uid = '',
    this.nickname = '',
    this.avatar = '',
    this.inviteCode = '',
    this.inviteCount = 0,
    this.todayEarned = 0,
    this.token,
  });

  UserState copyWith({
    int? points,
    String? uid,
    String? nickname,
    String? avatar,
    String? inviteCode,
    int? inviteCount,
    int? todayEarned,
    String? token,
  }) {
    return UserState(
      points: points ?? this.points,
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteCount: inviteCount ?? this.inviteCount,
      todayEarned: todayEarned ?? this.todayEarned,
      token: token ?? this.token,
    );
  }

  factory UserState.fromJson(Map<String, dynamic> json) {
    return UserState(
      points: json['score'] ?? json['points'] ?? json['coin'] ?? 0,
      uid: (json['id'] ?? '').toString(),
      nickname: json['nickname'] ?? json['username'] ?? '',
      avatar: json['avatar'] ?? '',
      inviteCode: json['invite_code'] ?? json['inviteCode'] ?? '',
      inviteCount: json['invite_count'] ?? json['inviteCount'] ?? 0,
      todayEarned: json['today_earned'] ?? json['todayEarned'] ?? 0,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': points,
      'id': uid,
      'nickname': nickname,
      'avatar': avatar,
      'invite_code': inviteCode,
      'invite_count': inviteCount,
      'today_earned': todayEarned,
      'token': token,
    };
  }
}

/// Notification model
class AppNotification {
  final String id;
  final String type;
  final String title;
  final String body;
  final String time;
  final bool read;
  final int? points;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
    this.points,
  });

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      time: time,
      read: read ?? this.read,
      points: points,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] ?? '').toString(),
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? json['content'] ?? '',
      time: json['time'] ?? json['createtime'] ?? json['created_at'] ?? '',
      read: json['is_read'] ?? json['read'] ?? false,
      points: json['points'] ?? json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'time': time,
      'is_read': read,
      'points': points,
    };
  }
}

/// Address model
class Address {
  final String id;
  final String name;
  final String phone;
  final String province;
  final String city;
  final String district;
  final String detail;
  final bool isDefault;

  const Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.province,
    required this.city,
    required this.district,
    required this.detail,
    this.isDefault = false,
  });

  Address copyWith({
    String? id,
    String? name,
    String? phone,
    String? province,
    String? city,
    String? district,
    String? detail,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      detail: detail ?? this.detail,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: (json['id'] ?? '').toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? json['mobile'] ?? '',
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? json['area'] ?? '',
      detail: json['detail'] ?? json['address'] ?? '',
      isDefault: json['isDefault'] ?? json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'province': province,
      'city': city,
      'district': district,
      'detail': detail,
      'isDefault': isDefault,
    };
  }
}

/// Category model
class Category {
  final int? id;
  final String key;
  final String label;
  final String emoji;

  const Category({
    this.id,
    required this.key,
    required this.label,
    required this.emoji,
  });

  Category copyWith({
    int? id,
    String? key,
    String? label,
    String? emoji,
  }) {
    return Category(
      id: id ?? this.id,
      key: key ?? this.key,
      label: label ?? this.label,
      emoji: emoji ?? this.emoji,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      key: (json['id'] ?? json['key'] ?? '').toString(),
      label: json['label'] ?? json['name'] ?? json['title'] ?? '',
      emoji: json['emoji'] ?? json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'label': label,
      'emoji': emoji,
    };
  }
}
