import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/home_page/custom_button.dart';

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
  // final WalletValidationModel validationModel = WalletValidationModel();

  var _numberForm = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();
  String _value = '';
  bool valid = false;
  bool isDeposit = true;
  RegExp _digitRegex = RegExp("[0-9]+");
  bool isValidForm = false;

  void _onEditingComplete() async {
    if (isValidForm) {
      _focusNode.unfocus();
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        textInputAction: TextInputAction.next,
                        keyboardAppearance: Brightness.light,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              return null;
                            }
                          });
                        },
                        validator: (inputValue) {
                          if (inputValue.isEmpty ||
                              !_digitRegex.hasMatch(inputValue)) {
                            return "Please enter an integer number!";
                          }
                          return null;
                        },
                        onEditingComplete: _onEditingComplete,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                  ),
                ),
              ),
              CustomButton(
                text: widget.buttonText,
                onPressed: toBlockchain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toBlockchain() async {
    if (_numberForm.currentState.validate()) {
      BigInt amount = BigInt.from(int.parse(_value));
      if (isDeposit) {
        await context.read(ethereumUtilsProvider).writeToContract(
          Constants.addDepositAmount,
          [amount],
        );
        print("Deposited amount: $amount");
      } else {
        await context
            .read(ethereumUtilsProvider)
            .writeToContract(Constants.withdrawBalance, [amount]);
        print("Widthdrawn amount: $amount");
      }
    }
    print("Input runtimeType: ${_value.runtimeType}");
    // valid = validationModel.isIntFormatter
    if (valid) {
    } else {
      print("Not working!");
    }

    setState(() {});
    widget.textController.clear();
  }
}
