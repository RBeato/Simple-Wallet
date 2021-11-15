import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

enum FormType { deposit, widthraw }

class InputForm extends StatefulWidget {
  InputForm({
    Key key,
    this.textController,
    this.labelText,
    this.hintText,
    this.formtype,
    this.buttonText,
  }) : super(key: key);

  final TextEditingController textController;
  final String labelText;
  final String hintText;
  final String buttonText;
  final FormType formtype;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var _numberForm = GlobalKey<FormState>();
  // String _value = '';
  bool isDeposit = true;

  @override
  Widget build(BuildContext context) {
    isDeposit = widget.formtype == FormType.deposit;
    TextEditingController controller = widget.textController;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Form(
          key: _numberForm,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10, right: 10.0, bottom: 20.0),
                child: Form(
                  child: TextFormField(
                      autovalidateMode:
                          AutovalidateMode.onUserInteraction, //s _autoValidate,
                      key: const Key('address_to'),
                      keyboardType: TextInputType.number,
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: widget.labelText,
                          hintText: widget.hintText,
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.8)),
                          labelStyle: TextStyle(color: Colors.black45)),
                      autocorrect: false,
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      keyboardAppearance: Brightness.light,
                      // onChanged: (value) {
                      //   setState(() {});
                      // },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
              ),
              CustomButton(
                text: widget.buttonText,
                opacity: controller.text == '' || int.parse(controller.text) < 0
                    ? 0.3
                    : 1.0,
                onPressed: () async {
                  BigInt amount = BigInt.from(int.parse(controller.text));
                  print("Amount : $amount");

                  if (isDeposit) {
                    await context.read(ethereumUtilsProvider).writeToContract(
                      Constants.addDepositAmount,
                      [amount],
                    );
                    print("Deposited amount: $amount");
                  } else {
                    await context
                        .read(ethereumUtilsProvider)
                        .writeToContract(Constants.withdrawAmount, [amount]);
                    print("Widthdrawn amount: $amount");
                  }

                  widget.textController.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//   void toBlockchain() async {
//                   if (_value == '' || int.parse(_value) < 0) {
//                     return;
//                   } else {
//                     BigInt amount = BigInt.from(int.parse(_value));
//                     print("Amount : $amount");
//                     if (isDeposit) {
//                       await context.read(ethereumUtilsProvider).writeToContract(
//                         Constants.addDepositAmount,
//                         [amount],
//                       );
//                       print("Deposited amount: $amount");
//                     } else {
//                       await context
//                           .read(ethereumUtilsProvider)
//                           .writeToContract(Constants.withdrawAmount, [amount]);
//                       print("Widthdrawn amount: $amount");
//                     }
//                   }
//                   setState(() {});
//                   context
//                       .read(autoValidateProvider.notifier)
//                       .setMode(AutovalidateMode.disabled);
//                   widget.textController.clear();
//                 },
// }
