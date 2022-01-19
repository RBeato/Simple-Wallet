import 'package:flutter/material.dart';

import 'wallet_info.dart';
import 'input_form.dart';

class WalletFunctionality extends StatelessWidget {
  const WalletFunctionality({
    Key? key,
    required this.depositController,
    required this.withdrawController,
  }) : super(key: key);

  final TextEditingController depositController;
  final TextEditingController withdrawController;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      WalletInfo(),
      Column(
        children: [
          InputForm(
            formType: FormType.deposit,
            textController: depositController,
            labelText: "Amount to deposit (in eth)",
            hintText: "2",
            buttonText: "Deposit",
          ),
          InputForm(
            formType: FormType.withdraw,
            textController: withdrawController,
            labelText: "Amount to withdraw (in eth)",
            hintText: "1 eth",
            buttonText: "Withdraw",
          ),
        ],
      )
    ]);
  }
}
