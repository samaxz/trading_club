import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  final String? imagePath;
  final String? name;
  final bool onboardingShown;
  final Image? image;
  final double balance;

  const UserInfo.initial()
      : imagePath = null,
        name = null,
        onboardingShown = false,
        image = null,
        balance = 12000;

  const UserInfo({
    required this.imagePath,
    required this.name,
    required this.onboardingShown,
    required this.image,
    required this.balance,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserInfo &&
          runtimeType == other.runtimeType &&
          imagePath == other.imagePath &&
          name == other.name &&
          onboardingShown == other.onboardingShown &&
          image == other.image &&
          balance == other.balance);

  @override
  int get hashCode =>
      imagePath.hashCode ^
      name.hashCode ^
      onboardingShown.hashCode ^
      image.hashCode ^
      balance.hashCode;

  @override
  String toString() =>
      'UserInfo{ imagePath: $imagePath, name: $name, onboardingShown: $onboardingShown, image: $image, balance: $balance}';

  UserInfo copyWith({
    String? imagePath,
    String? name,
    bool? onboardingShown,
    Image? image,
    double? balance,
  }) {
    return UserInfo(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      onboardingShown: onboardingShown ?? this.onboardingShown,
      image: image ?? this.image,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'name': name,
      'onboardingShown': onboardingShown,
      'image': image,
      'balance': balance,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      imagePath: map['imagePath'] as String,
      name: map['name'] as String,
      onboardingShown: map['onboardingShown'] as bool,
      image: map['image'] as Image,
      balance: map['balance'] as double,
    );
  }
}

// TODO refactor methods here to use user info json
class UserInfoNotifier extends StateNotifier<UserInfo> {
  final SharedPreferences prefs;

  UserInfoNotifier(this.prefs)
      : super(
          const UserInfo.initial(),
        ) {
    // TODO add null check here and make a unique user id
    // using uid or just a randomly generated number, idk
    // final name = getName();
    // if (name == null) {
    //   setName('User');
    // }
    // final imagePath = getImagePath();
    // if (imagePath == null) {
    //   setImagePath(path)
    // }
    // final onboardingShown = onboardingShown();
    // final balance = getBalance();
    // // TODO remove this, cause the default balance is already
    // // 12 000
    // if (balance == null) {
    //   setBalance(12000);
    // }

    state = state.copyWith(
      name: _getName(),
      imagePath: _getImagePath(),
      onboardingShown: _onboardingShown(),
      balance: getBalance(),
    );
  }

  String _formatNumber(int number) {
    String newNumber = number.toString();
    final numberList = newNumber.split('');

    if (numberList.length == 3) {
      numberList.insert(0, '0');
    } else if (numberList.length == 2) {
      numberList.insertAll(
        0,
        // List.generate(2, (index) => '0'),
        ['0', '0'],
      );
    } else if (numberList.length == 1) {
      numberList.insertAll(
        0,
        ['0', '0', '0'],
      );
    }
    newNumber = numberList.join('');

    return newNumber;
  }

  // initialize values for shared prefs
  // this'll get called once the user makes it to the home screen
  Future<void> setInitialInfo() async {
    final name = _getName();
    if (name == null) {
      await setName('User#${_formatNumber(math.Random().nextInt(10000))}');
    }
    // final imagePath = getImagePath();
    // if (imagePath == null) {
    //   setImagePath(path);
    // }
    final onbShown = _onboardingShown();
    if (onbShown == null) {
      await showOnboarding();
    }
    final balance = getBalance();
    if (balance == null) {
      await setBalance(12000);
    }
  }

  // ********************
  Future<void> showOnboarding() async {
    await prefs.setBool('onboarding_shown', true);
    state = state.copyWith(onboardingShown: true);
    // log('onboard is: ${state.onboardingShown}');
  }

  Future<void> hideOnboarding() async {
    await prefs.setBool('onboarding_shown', false);
    state = state.copyWith(onboardingShown: false);
  }

  bool? _onboardingShown() => prefs.getBool('onboarding_shown');

  // *********************
  Future<void> setImagePath(String path) async {
    await prefs.setString('image_path', path);
    state = state.copyWith(imagePath: path);
  }

  String? _getImagePath() => prefs.getString('image_path');

  // ********************
  Future<void> setName(String newName) async {
    await prefs.setString('username', newName);
    state = state.copyWith(name: newName);
    // log('new name is: $newName');
  }

  String? _getName() => prefs.getString('username');

  // ********************
  Future<void> setBalance(double newBalance) async {
    await prefs.setDouble('balance', newBalance);
    state = state.copyWith(balance: newBalance);
  }

  // double getBalance() {
  //   if (prefs.getDouble('balance') == null) {
  //     return 12000;
  //   }
  //
  //   return prefs.getDouble('balance')!;
  // }
  double? getBalance() => prefs.getDouble('balance');
}

// **************************
// TODO remove this
@deprecated
class UserInfoSharedPrefs {
  final SharedPreferences prefs;

  const UserInfoSharedPrefs(this.prefs);

  // **********************
  Future<void> showOnboard() async {
    await prefs.setBool('onboarding_shown', true);
  }

  Future<void> hideOnboarding() async {
    await prefs.setBool('onboarding_shown', false);
  }

  bool? onboardingShown() => prefs.getBool('onboarding_shown');
  // *******************

  Future<void> setImagePath(String path) async {
    await prefs.setString('image_path', path);
  }

  String? getImagePath() => prefs.getString('image_path');

  // this'll be used to store avatar image as a string
  Future<void> storeImage(String image) async {}

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  // ********************
  Future<void> setName(String newName) async {
    await prefs.setString('username', newName);
    // state = state.copyWith();
    // log('new name is: $newName');
  }

  String? getName() => prefs.getString('username');
}

final userInfoSharedPrefsNP = StateNotifierProvider<UserInfoNotifier, UserInfo>(
  (ref) => UserInfoNotifier(
    ref.read(sharedPrefsP),
  ),
);

// *******************
// final userInfoSharedPrefsP = Provider(
//   (ref) => UserInfoSharedPrefs(
//     ref.read(sharedPrefsP),
//   ),
// );

final sharedPrefsP = Provider<SharedPreferences>(
  // (ref) => SharedPreferences.getInstance(),
  (ref) => throw UnimplementedError(),
);
