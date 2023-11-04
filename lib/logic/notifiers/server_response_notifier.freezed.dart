// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_response_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ScreensState _$ScreensStateFromJson(Map<String, dynamic> json) {
  return _ScreensState.fromJson(json);
}

/// @nodoc
mixin _$ScreensState {
  bool get onboardingShown => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScreensStateCopyWith<ScreensState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreensStateCopyWith<$Res> {
  factory $ScreensStateCopyWith(
          ScreensState value, $Res Function(ScreensState) then) =
      _$ScreensStateCopyWithImpl<$Res, ScreensState>;
  @useResult
  $Res call({bool onboardingShown});
}

/// @nodoc
class _$ScreensStateCopyWithImpl<$Res, $Val extends ScreensState>
    implements $ScreensStateCopyWith<$Res> {
  _$ScreensStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onboardingShown = null,
  }) {
    return _then(_value.copyWith(
      onboardingShown: null == onboardingShown
          ? _value.onboardingShown
          : onboardingShown // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScreensStateImplCopyWith<$Res>
    implements $ScreensStateCopyWith<$Res> {
  factory _$$ScreensStateImplCopyWith(
          _$ScreensStateImpl value, $Res Function(_$ScreensStateImpl) then) =
      __$$ScreensStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool onboardingShown});
}

/// @nodoc
class __$$ScreensStateImplCopyWithImpl<$Res>
    extends _$ScreensStateCopyWithImpl<$Res, _$ScreensStateImpl>
    implements _$$ScreensStateImplCopyWith<$Res> {
  __$$ScreensStateImplCopyWithImpl(
      _$ScreensStateImpl _value, $Res Function(_$ScreensStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onboardingShown = null,
  }) {
    return _then(_$ScreensStateImpl(
      onboardingShown: null == onboardingShown
          ? _value.onboardingShown
          : onboardingShown // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScreensStateImpl implements _ScreensState {
  const _$ScreensStateImpl({required this.onboardingShown});

  factory _$ScreensStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScreensStateImplFromJson(json);

  @override
  final bool onboardingShown;

  @override
  String toString() {
    return 'ScreensState(onboardingShown: $onboardingShown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScreensStateImpl &&
            (identical(other.onboardingShown, onboardingShown) ||
                other.onboardingShown == onboardingShown));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, onboardingShown);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScreensStateImplCopyWith<_$ScreensStateImpl> get copyWith =>
      __$$ScreensStateImplCopyWithImpl<_$ScreensStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScreensStateImplToJson(
      this,
    );
  }
}

abstract class _ScreensState implements ScreensState {
  const factory _ScreensState({required final bool onboardingShown}) =
      _$ScreensStateImpl;

  factory _ScreensState.fromJson(Map<String, dynamic> json) =
      _$ScreensStateImpl.fromJson;

  @override
  bool get onboardingShown;
  @override
  @JsonKey(ignore: true)
  _$$ScreensStateImplCopyWith<_$ScreensStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
