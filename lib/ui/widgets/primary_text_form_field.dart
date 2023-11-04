import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/timer_notifier.dart';
import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:trading_club/ui/screens/home_screen.dart';
import 'package:trading_club/ui/screens/simulator_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String removeDecimalZeroFormat(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}

String removeTrailingZeros(String n) {
  return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}

String removeTrailingZero(String string) {
  if (!string.contains('.')) {
    return string;
  }

  string = string.replaceAll(RegExp(r'0*$'), '');

  if (string.endsWith('.')) {
    string = string.substring(0, string.length - 1);
  }

  return string;
}

extension ToString on double {
  String toStringWithMaxPrecision({int? maxDigits}) {
    if (round() == this) {
      return round().toString();
    } else {
      if (maxDigits == null) {
        return toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      } else {
        return toStringAsFixed(maxDigits).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      }
    }
  }
}

extension MeineVer on double {
  // String get toMoney => '$removeTrailingZeros₺';
  String get removeTrailingZeros {
    // return if complies to int
    if (this % 1 == 0) return toInt().toString();
    // remove trailing zeroes
    String str = '$this'.replaceAll(RegExp(r'0*$'), '');
    // reduce fraction max length to 2
    if (str.contains('.')) {
      final fr = str.split('.');
      if (2 < fr[1].length) {
        str = '${fr[0]}.${fr[1][0]}${fr[1][1]}';
      }
    }
    return str;
  }
}

final textFormFieldControllerP = Provider(
  (ref) => TextEditingController(
    text: double.parse(
      ref.watch(bidAmountSP).toString(),
    ).removeTrailingZeros,
  ),
);

class CustomTextFormField extends ConsumerStatefulWidget {
  const CustomTextFormField({super.key});

  @override
  ConsumerState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends ConsumerState<CustomTextFormField> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(textFormFieldControllerP);
    final userInfo = ref.watch(userInfoSharedPrefsNP);
    final selectedPair = ref.watch(selectedPairSP);

    return Expanded(
      child: Form(
        key: formKey,
        child: TextFormField(
          autofocus: false,
          onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                color: Helper.greyTile,
                // ***** this is the pop-up text field
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  initialValue: controller.text,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  onFieldSubmitted: (text) {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  autofocus: true,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'bid shouldn`t be empty';
                    } else if (userInfo.balance < double.parse(text)) {
                      return 'you don`t have enough balance';
                    }

                    return null;
                  },
                  onChanged: (text) {
                    if (double.tryParse(text) == null) {
                      return;
                    }

                    controller.text = double.parse(text).removeTrailingZeros;

                    ref.read(bidAmountSP.notifier).update((state) => double.tryParse(text) ?? 0);

                    if (text == null || text.isEmpty) {
                      ref.read(disableBidSP.notifier).update(
                            (state) => {...state, selectedPair: true},
                          );
                    } else if (userInfo.balance <= 0) {
                      showCupertinoModalPopup<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Theme(
                            data: ThemeData.light(),
                            child: CupertinoAlertDialog(
                              title: Text(
                                'Your balance is zero',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.40,
                                ),
                              ),
                              content: Text(
                                'Your progress and balance will be reset to defaults',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.40,
                                ),
                              ),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  isDestructiveAction: false,
                                  onPressed: () async {
                                    await ref
                                        .read(userInfoSharedPrefsNP.notifier)
                                        .setBalance(12000);

                                    ref.read(disableBidSP.notifier).update(
                                          (state) => {selectedPair: false},
                                        );

                                    if (!mounted) {
                                      return;
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Reset',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFFCA3131),
                                      fontSize: 20.sp,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (userInfo.balance < double.parse(text)) {
                      ref.read(disableBidSP.notifier).update(
                            (state) => {...state, selectedPair: true},
                          );
                    } else if (double.parse(text) == 0) {
                      ref.read(disableBidSP.notifier).update(
                            (state) => {...state, selectedPair: true},
                          );
                    } else {
                      ref.read(disableBidSP.notifier).update(
                            (state) => {...state, selectedPair: false},
                          );
                    }
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.10,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // isCollapsed: true,
                    contentPadding: EdgeInsets.all(8.r),
                  ),
                ),
              ),
            ),
          ),
          // **** this is the primary text form field
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          readOnly: true,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d*\.?\d{0,2}'),
            ),
          ],
          controller: controller,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'bid shouldn`t be empty';
            } else if (userInfo.balance < double.parse(text)) {
              return 'you don`t have enough balance';
            }

            return null;
          },
          onChanged: (text) {
            ref.read(bidAmountSP.notifier).update((state) => double.tryParse(text) ?? 0);

            if (text == null || text.isEmpty) {
              ref.read(disableBidSP.notifier).update(
                    (state) => {...state, selectedPair: true},
                  );
            } else if (userInfo.balance <= 0) {
              showCupertinoModalPopup<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Theme(
                    data: ThemeData.light(),
                    child: CupertinoAlertDialog(
                      title: Text(
                        'Your balance is zero',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.40,
                        ),
                      ),
                      content: Text(
                        'Your progress and balance will be reset to defaults',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.40,
                        ),
                      ),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDestructiveAction: false,
                          onPressed: () async {
                            await ref.read(userInfoSharedPrefsNP.notifier).setBalance(12000);

                            ref.read(disableBidSP.notifier).update(
                                  (state) => {selectedPair: false},
                                );

                            if (!mounted) {
                              return;
                            }

                            Navigator.pop(context);
                          },
                          child: Text(
                            'Reset',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFCA3131),
                              fontSize: 20.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (userInfo.balance == double.parse(text)) {
              ref.read(disableBidSP.notifier).update(
                    (state) => {...state, selectedPair: false},
                  );
            } else if (userInfo.balance < double.parse(text)) {
              ref.read(disableBidSP.notifier).update(
                    (state) => {...state, selectedPair: true},
                  );
            } else {
              ref.read(disableBidSP.notifier).update(
                    (state) => {...state, selectedPair: false},
                  );
            }
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.10,
          ),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
