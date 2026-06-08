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

  const ContentItem({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.image,
    required this.likes,
    required this.views,
    this.height,
  });
}

/// Mall product model
class MallProduct {
  final String id;
  final String name;
  final int points;
  final String image;
  final String? tag;
  final int stock;

  const MallProduct({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
    this.tag,
    required this.stock,
  });
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

  const UserState({
    this.points = 1280,
    this.uid = 'U88612345',
    this.nickname = '积分达人',
    this.avatar = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80',
    this.inviteCode = 'JF88612',
    this.inviteCount = 7,
    this.todayEarned = 320,
  });

  UserState copyWith({
    int? points,
    String? uid,
    String? nickname,
    String? avatar,
    String? inviteCode,
    int? inviteCount,
    int? todayEarned,
  }) {
    return UserState(
      points: points ?? this.points,
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteCount: inviteCount ?? this.inviteCount,
      todayEarned: todayEarned ?? this.todayEarned,
    );
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
}

/// Category model
class Category {
  final String key;
  final String label;
  final String emoji;

  const Category({required this.key, required this.label, required this.emoji});
}
