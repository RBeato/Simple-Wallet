import 'package:flutter/material.dart';

import 'check_investment.dart';
import 'input_form.dart';

class MainColumn extends StatelessWidget {
  const MainColumn({
    Key key,
    @required this.formKey,
    @required this.depositController,
    @required this.widthrawController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController depositController;
  final TextEditingController widthrawController;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      CheckBalances(),
      Column(
        children: [
          InputForm(
            formtype: FormType.deposit,
            textController: depositController,
            labelText: "Amount to deposit (in eth)",
            hintText: "2",
            buttonText: "Deposit",
          ),
          InputForm(
            formtype: FormType.widthraw,
            textController: widthrawController,
            labelText: "Amount to widthraw (in eth)",
            hintText: "1 eth",
            buttonText: "Widthraw",
          ),
        ],
      )
    ]);
  }
}
