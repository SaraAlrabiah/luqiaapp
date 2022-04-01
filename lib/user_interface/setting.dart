import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/localization/localization_services.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:pay/pay.dart';

import 'package:flutter_braintree/flutter_braintree.dart';

import '../main.dart';
import '../operation/dashboard.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, required uid}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  var currentUser = FirebaseAuth.instance.currentUser;

  late String lng;
  bool _1monthG = true;
  bool _1monthS = true;
  bool _1yearG = true;
  bool _1yearS = true;
  bool _3month = true;
  bool _6month = true;
  bool _1year = true;
  bool _5year = true;
  final _paymentItems = <PaymentItem>[];
  @override
  void initState() {
    super.initState();
    lng = LocalizationService().getCurrentLang();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var currentUser = FirebaseAuth.instance.currentUser;
            UserHelper.saveUser(currentUser);
            final uid = currentUser!.uid;
            Dashboard.userDashboard(uid);
            var email = currentUser.email;
            var name = currentUser.displayName;

            void onGooglePayResult(paymentResult) {
              debugPrint(paymentResult.toString());
            }

            void onApplePayResult(paymentResult) {
              debugPrint(paymentResult.toString());
            }

            Size size = MediaQuery.of(context).size;
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            //  fontWeight: ,
                            // fontFamily: titleFontFamily,
                            fontSize: 25.0),
                      ),
                      Text('    $name'),
                    ]),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios , color: Colors.black,),
                ),
                actions: <Widget>[
                  IconButton(

                    icon: const Icon(Icons.logout , color: Colors.black,) ,

                    tooltip: 'Logout',
                    onPressed: () {
                      AuthHelper.logOut();
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: _uiWidget(name, email!),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                UserHelper.saveUser(snapshot.data!);
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(snapshot.data!.uid)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final userDoc = snapshot.data;

                                      final user = userDoc!.data();
                                      if ((user as Map<String, dynamic>)[
                                              'role'] ==
                                          'admin') {
                                        return Card(
                                          child: Text('  '),
                                        );
                                      } else if ((user)['role'] ==
                                          'companyUser') {
                                        print(size.width);
                                        return SizedBox(
                                          width: size.width * 0.99,
                                          height: size.height * 0.25,
                                          child: Card(
                                            color: Colors.blueGrey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _3month
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _3month = !_3month;
                                                            if (_6month ==
                                                                    false ||
                                                                _1year ==
                                                                    false ||
                                                                _5year ==
                                                                    false) {
                                                              _6month = true;
                                                              _1year = true;
                                                              _5year = true;
                                                            }
                                                            _paymentItems
                                                                .clear();
                                                            _paymentItems.add(
                                                                const PaymentItem(
                                                                    amount:
                                                                        '10',
                                                                    label:
                                                                        'Luqia'));
                                                          });
                                                        },
                                                        child:
                                                            Text('3 month'.tr)),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _6month
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _6month = !_6month;
                                                            if (_3month ==
                                                                    false ||
                                                                _1year ==
                                                                    false ||
                                                                _5year ==
                                                                    false) {
                                                              _3month = true;
                                                              _1year = true;
                                                              _5year = true;
                                                            }
                                                            _paymentItems
                                                                .clear();
                                                            _paymentItems.add(
                                                                const PaymentItem(
                                                                    amount:
                                                                        '6 month',
                                                                    label:
                                                                        'Luqia'));
                                                          });
                                                        },
                                                        child:
                                                            Text('6 month'.tr)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _1year
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _1year = !_1year;
                                                            if (_6month == false ||
                                                                _3month ==
                                                                    false ||
                                                                _5year ==
                                                                    false) {
                                                              _6month = true;
                                                              _3month = true;
                                                              _5year = true;
                                                            }
                                                            _paymentItems
                                                                .clear();

                                                            _paymentItems.add(
                                                                const PaymentItem(
                                                                    amount:
                                                                        '1 year',
                                                                    label:
                                                                        'Luqia'));
                                                          });
                                                        },
                                                        child:
                                                            Text('1 year'.tr)),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _5year
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _5year = !_5year;
                                                            if (_6month ==
                                                                    false ||
                                                                _1year ==
                                                                    false ||
                                                                _3month ==
                                                                    false) {
                                                              _6month = true;
                                                              _1year = true;
                                                              _3month = true;
                                                            }
                                                            _paymentItems
                                                                .clear();
                                                            _paymentItems.add(
                                                                const PaymentItem(
                                                                    amount:
                                                                        '5 Year',
                                                                    label:
                                                                        'Luqia'));
                                                          });
                                                        },
                                                        child:
                                                            Text('5 Year'.tr)),
                                                    // ElevatedButton(
                                                    //     onPressed: () {},
                                                    //     child: const Text('Silver subscription ')),
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      GooglePayButton(
                                                        paymentConfigurationAsset:
                                                            'default_payment_profile_google_pay.json',
                                                        paymentItems:
                                                            _paymentItems,
                                                        style:
                                                            GooglePayButtonStyle
                                                                .white,
                                                        type:
                                                            GooglePayButtonType
                                                                .subscribe,
                                                        width:
                                                            size.width * 0.40,
                                                        height:
                                                            size.height * 0.05,
                                                        margin: const EdgeInsets
                                                            .only(top: 15.0),
                                                        onPaymentResult:
                                                            onGooglePayResult,
                                                        loadingIndicator:
                                                            const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                      ApplePayButton(
                                                        paymentConfigurationAsset:
                                                            'default_payment_profile_apple_pay.json',
                                                        paymentItems:
                                                            _paymentItems,

                                                        width:
                                                            size.width * 0.40,
                                                        height:
                                                            size.height * 0.05,
                                                        style:
                                                            ApplePayButtonStyle
                                                                .black,
                                                        type: ApplePayButtonType
                                                            .subscribe,
                                                        // margin:
                                                        //     const EdgeInsets.only(
                                                        //         top: 15.0),
                                                        onPaymentResult:
                                                            onApplePayResult,
                                                        loadingIndicator:
                                                            const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.40,
                                                        height:
                                                            size.height * 0.05,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            final request =
                                                                BraintreeDropInRequest(
                                                                    tokenizationKey:
                                                                        'sandbox_mfpvf5gy_8vnhdprsnv2vks96',
                                                                    collectDeviceData:
                                                                        true,
                                                                    googlePaymentRequest:
                                                                        BraintreeGooglePaymentRequest(
                                                                      totalPrice:
                                                                          '4.20',
                                                                      currencyCode:
                                                                          'USD',
                                                                      billingAddressRequired:
                                                                          false,
                                                                    ),
                                                                    paypalRequest: BraintreePayPalRequest(
                                                                        amount:
                                                                            '10.00',
                                                                        displayName:
                                                                            'Luqia'),
                                                                    cardEnabled:
                                                                        true);
                                                            BraintreeDropInResult?
                                                                result =
                                                                await BraintreeDropIn
                                                                    .start(
                                                                        request);
                                                            if (result !=
                                                                null) {
                                                              print(result
                                                                  .paymentMethodNonce
                                                                  .description);
                                                              print(result
                                                                  .paymentMethodNonce
                                                                  .nonce);
                                                            }
                                                          },
                                                          child: Text('Pay'.tr),
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if ((user)['role'] ==
                                          'normalUser') {
                                        return SizedBox(
                                          width: size.width * 0.99,
                                          height: size.height * 0.25,
                                          child: Card(
                                            color: Colors.grey[200],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _1monthG
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _1monthG =
                                                                !_1monthG;
                                                            if (_1yearG == false ||
                                                                _1yearS ==
                                                                    false ||
                                                                _1monthS ==
                                                                    false) {
                                                              _1yearS = true;
                                                              _1yearG = true;
                                                              _1monthS = true;
                                                            }
                                                            _paymentItems
                                                                .clear();
                                                            _paymentItems.add(
                                                                const PaymentItem(
                                                                    amount:
                                                                        '10',
                                                                    label:
                                                                        'Luqia'));
                                                          });
                                                        },
                                                        child:
                                                            Text('1 Month'.tr)),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _1yearG
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _1yearG = !_1yearG;
                                                            if (_1monthG ==
                                                                    false ||
                                                                _1yearS ==
                                                                    false ||
                                                                _1monthS ==
                                                                    false) {
                                                              _1yearS = true;
                                                              _1monthG = true;
                                                              _1monthS = true;
                                                            }
                                                            _paymentItems
                                                                .clear();
                                                            _paymentItems.add(
                                                                const PaymentItem(
                                                                    amount:
                                                                        '100',
                                                                    label:
                                                                        'Luqia'));
                                                          });
                                                        },
                                                        child:
                                                            Text('1 Year'.tr)),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.star,
                                                        size: size.width * 0.10,
                                                        color: Colors.amber,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _1monthS
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _1monthS =
                                                                !_1monthS;
                                                            if (_1yearG == false ||
                                                                _1yearS ==
                                                                    false ||
                                                                _1monthG ==
                                                                    false) {
                                                              _1yearS = true;
                                                              _1yearG = true;
                                                              _1monthG = true;
                                                            }
                                                            _paymentItems
                                                                .clear();
                                                            print(_paymentItems
                                                                .length);
                                                            _paymentItems.add(
                                                                PaymentItem(
                                                              amount: '7',
                                                              label: 'Luqia',
                                                              status:
                                                                  PaymentItemStatus
                                                                      .final_price,
                                                            ));
                                                            print(_paymentItems
                                                                .length);
                                                          });
                                                        },
                                                        child:
                                                            Text('1 Month'.tr)),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _1yearS
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _1yearS = !_1yearS;
                                                            if (_1yearG ==
                                                                    false ||
                                                                _1monthS ==
                                                                    false ||
                                                                _1monthG ==
                                                                    false) {
                                                              _1monthG = true;
                                                              _1yearG = true;
                                                              _1monthS = true;
                                                            }
                                                          });

                                                          _paymentItems.clear();
                                                          _paymentItems.add(
                                                              const PaymentItem(
                                                                  amount: '70',
                                                                  label:
                                                                      'Luqia'));
                                                        },
                                                        child:
                                                            Text('1 Year'.tr)),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.star,
                                                        size: size.width * 0.10,
                                                        color: Colors.grey,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      GooglePayButton(
                                                        paymentConfigurationAsset:
                                                            'default_payment_profile_google_pay.json',
                                                        paymentItems:
                                                            _paymentItems,
                                                        style:
                                                            GooglePayButtonStyle
                                                                .white,
                                                        type:
                                                            GooglePayButtonType
                                                                .subscribe,
                                                        width:
                                                            size.width * 0.40,
                                                        height:
                                                            size.height * 0.05,
                                                        onPaymentResult:
                                                            onGooglePayResult,
                                                        loadingIndicator:
                                                            const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                      ApplePayButton(
                                                        paymentConfigurationAsset:
                                                            'default_payment_profile_apple_pay.json',
                                                        paymentItems:
                                                            _paymentItems,
                                                        width:
                                                            size.width * 0.40,
                                                        height:
                                                            size.height * 0.05,
                                                        style:
                                                            ApplePayButtonStyle
                                                                .black,
                                                        type: ApplePayButtonType
                                                            .subscribe,
                                                        onPaymentResult:
                                                            onApplePayResult,
                                                        loadingIndicator:
                                                            const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.40,
                                                        height:
                                                            size.height * 0.05,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            final request =
                                                                BraintreeDropInRequest(
                                                                    tokenizationKey:
                                                                        'sandbox_mfpvf5gy_8vnhdprsnv2vks96',
                                                                    collectDeviceData:
                                                                        true,
                                                                    googlePaymentRequest:
                                                                        BraintreeGooglePaymentRequest(
                                                                      totalPrice:
                                                                          '4.20',
                                                                      currencyCode:
                                                                          'USD',
                                                                      billingAddressRequired:
                                                                          false,
                                                                    ),
                                                                    paypalRequest: BraintreePayPalRequest(
                                                                        amount:
                                                                            '10.00',
                                                                        displayName:
                                                                            'Luqia'),
                                                                    cardEnabled:
                                                                        true);
                                                            BraintreeDropInResult?
                                                                result =
                                                                await BraintreeDropIn
                                                                    .start(
                                                                        request);
                                                            if (result !=
                                                                null) {
                                                              print(result
                                                                  .paymentMethodNonce
                                                                  .description);
                                                              print(result
                                                                  .paymentMethodNonce
                                                                  .nonce);
                                                            }
                                                          },
                                                          child: Text('Pay'.tr),
                                                        ),
                                                      )
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Material(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    } else {
                                      return const Material(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                              return const Material(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            })
                      ],
                    ),
                    // ),
                  ],
                ),
              ),
              //   ],
              // ),
            );
          } else {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget _uiWidget(String? name, String email) {
    var currentUser = FirebaseAuth.instance.currentUser;
    var email = currentUser!.email;
    var name = currentUser.displayName;

    UserHelper.saveUser(currentUser);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 30.0),
        const SizedBox(height: 30.0, width: 30.0),
        Text(
          '               PROFILE'.tr,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 50.0),
        Row(
          children: [
            Text(
              "          Name".tr,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 50.0),
            Text(name!),
          ],
        ),
        const SizedBox(height: 50.0),
        Row(
          children: [
            Text(
              "          Email".tr,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 50.0),
            Text(email!),
          ],
        ),
        const SizedBox(height: 50.0),
        Row(
          children: [
            Text(
              "          Language".tr,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 50.0),
            DropdownButton<String>(
              items: LocalizationService.langs.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: lng,
              underline: Container(color: Colors.transparent),
              isExpanded: false,
              onChanged: (newVal) {
                setState(() {
                  lng = newVal!;

                  LocalizationService().changeLocale(newVal);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
