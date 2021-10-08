import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/home_page/custom_text_form.dart';

import '../constants.dart';

class Deposit extends StatefulWidget {
  Deposit({
    Key key,
  }) : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final TextEditingController depositController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextForm(
          textController: depositController,
          labelText: "Amount to deposit (in eth)",
          hintText: "2 eth",
        ),
        CustomButton(
          text: "Deposit",
          onPressed: () async {
            BigInt depositValue =
                BigInt.from(int.parse(depositController.text));
            print("depositValue: $depositValue");
            print("depositValue: ${depositValue.runtimeType}");

            await context.read(ethereumUtilsProvider).writeToContract(
              Constants.addDepositAmount,
              [depositValue],
            );
            setState(() {});
          },
        ),
      ],
    );
  }
}
