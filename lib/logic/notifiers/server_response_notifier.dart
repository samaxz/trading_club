import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_response_notifier.freezed.dart';
part 'server_response_notifier.g.dart';

@freezed
class ScreensState with _$ScreensState {
  const factory ScreensState({
    required bool onboardingShown,
  }) = _ScreensState;

  factory ScreensState.fromJson(Map<String, dynamic> json) => _$ScreensStateFromJson(json);
}

class ScreensStateNotifier extends StateNotifier<ScreensState> {
  final Ref ref;

  late final prefs = ref.read(sharedPrefsP);

  ScreensStateNotifier(this.ref)
      : super(
          const ScreensState(onboardingShown: false),
        ) {
    _getPrefsDetails();
  }

  void _getPrefsDetails() {
    final onboardingShown = prefs.getBool('onboarding_shown');

    if (onboardingShown != null) {
      state = state.copyWith(
        onboardingShown: onboardingShown,
      );
    }
  }

  Future<void> setPrefsDetails({bool? onboardingShown}) async {
    if (onboardingShown != null) {
      await prefs.setBool(
        'onboarding_shown',
        onboardingShown,
      );

      state = state.copyWith(onboardingShown: onboardingShown);
    }
  }
}

final screensStateNP = StateNotifierProvider<ScreensStateNotifier, ScreensState>(
  (ref) => ScreensStateNotifier(ref),
);
