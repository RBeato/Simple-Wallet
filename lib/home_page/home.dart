import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/models/auto_validate_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../logo.dart';
import 'amount_input_forms.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  final TextEditingController depositController = TextEditingController();
  final TextEditingController widthrawController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Consumer(
          builder: (context, watch, _) {
            watch(ethereumUtilsProvider).initialSetup();
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[200],
                    Colors.blue[50],
                  ],
                  begin: const FractionalOffset(1.0, 1.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                    context
                        .read(autoValidateProvider.notifier)
                        .setMode(AutovalidateMode.disabled);
                  }
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: SvgPicture.asset(
                            "assets/images/eth_wallet.svg",
                            // height: 100,
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(children: [
                            Expanded(flex: 1, child: Container()),
                            Expanded(flex: 2, child: Logo()),
                            Expanded(
                              flex: 7,
                              child: AmountInputForms(
                                formKey: formKey,
                                depositController: depositController,
                                widthrawController: widthrawController,
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
