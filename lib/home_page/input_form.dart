import 'package:basic_wallet/models/auto_validate_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  FocusNode _focusNode = FocusNode();
  String _value = '';
  bool isDeposit = true;
  RegExp _digitRegex = RegExp("[0-9]+");
  AutovalidateMode _autoValidate;

  @override
  Widget build(BuildContext context) {
    isDeposit = widget.formtype == FormType.deposit;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Form(
          key: _numberForm,
          child: Column(
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10.0, bottom: 20.0),
                  child: Form(
                    child: TextFormField(
                        autovalidateMode: AutovalidateMode
                            .onUserInteraction, //s _autoValidate,
                        key: const Key('address_to'),
                        keyboardType: TextInputType.number,
                        controller: widget.textController,
                        decoration: InputDecoration(
                            labelText: widget.labelText,
                            hintText: widget.hintText,
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.8)),
                            labelStyle: TextStyle(color: Colors.black45)),
                        autocorrect: false,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        keyboardAppearance: Brightness.light,
                        onChanged: (value) {
                          setState(() {
                            context
                                .read(autoValidateProvider.notifier)
                                .setMode(AutovalidateMode.onUserInteraction);
                            _value = value;
                            print("OnChanged value $_value");
                            if (value.isEmpty) {
                              return null;
                            }
                          });
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                  ),
                ),
              ),
              CustomButton(
                  text: widget.buttonText,
                  opacity: _value == '' || int.parse(_value) < 0 ? 0.3 : 1.0,
                  onPressed: () async {
                    if (_value == '' || int.parse(_value) < 0) {
                      return;
                    } else {
                      BigInt amount = BigInt.from(int.parse(_value));
                      print("Amount : $amount");
                      // if (isDeposit) {
                      //   await context.read(ethereumUtilsProvider).writeToContract(
                      //     Constants.addDepositAmount,
                      //     [amount],
                      //   );
                      //   print("Deposited amount: $amount");
                      // } else {
                      //   await context
                      //       .read(ethereumUtilsProvider)
                      //       .writeToContract(Constants.withdrawBalance, [amount]);
                      //   print("Widthdrawn amount: $amount");
                      // }
                      // }
                      setState(() {});
                      context
                          .read(autoValidateProvider.notifier)
                          .setMode(AutovalidateMode.disabled);
                      widget.textController.clear();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // void toBlockchain() async {
  //   if (_numberForm.currentState.validate()) {
  //     BigInt amount = BigInt.from(int.parse(_value));
  //     print("Amount : $amount");
  //     if (isDeposit) {
  //       await context.read(ethereumUtilsProvider).writeToContract(
  //         Constants.addDepositAmount,
  //         [amount],
  //       );
  //       print("Deposited amount: $amount");
  //     } else {
  //       await context
  //           .read(ethereumUtilsProvider)
  //           .writeToContract(Constants.withdrawBalance, [amount]);
  //       print("Widthdrawn amount: $amount");
  //     }
  //   }
  //   print("Input runtimeType: ${_value.runtimeType}");
  //   // valid = validationModel.isIntFormatter
  //   if (valid) {
  //   } else {
  //     print("Not working!");
  //   }

  //   setState(() {});
  //   widget.textController.clear();
  // }
}
