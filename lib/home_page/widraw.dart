import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'custom_text_form.dart';

class Widthraw extends StatefulWidget {
  Widthraw({
    Key key,
  }) : super(key: key);

  @override
  _WidthrawState createState() => _WidthrawState();
}

class _WidthrawState extends State<Widthraw> {
  final TextEditingController widthrawController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextForm(
          textController: widthrawController,
          labelText: "Amount to widthraw (in eth)",
          hintText: "1 eth",
        ),
        CustomButton(
          text: "Withraw Balance",
          onPressed: () async {
            BigInt widthrawValue =
                BigInt.from(int.parse(widthrawController.text));

            await context
                .read(ethereumUtilsProvider)
                .writeToContract(Constants.withdrawBalance, [widthrawValue]);
            setState(() {});
          },
        ),
      ],
    );
  }
}
