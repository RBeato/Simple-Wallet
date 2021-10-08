import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomTextForm extends StatelessWidget {
  CustomTextForm({Key key, this.textController, this.labelText, this.hintText})
      : super(key: key);

  final TextEditingController textController;
  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Neumorphic(
        style: NeumorphicStyle(
          color: Colors.white.withOpacity(0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10.0, bottom: 8.0),
          child: TextFormField(
            key: const Key('address_to'),
            controller: textController,
            decoration: InputDecoration(
                // alignLabelWithHint: true,
                labelText: labelText,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                // errorText: model.emailErrorText,
                // enabled: !model.isLoading,
                labelStyle: TextStyle(color: Colors.black45)),
            autocorrect: false,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            keyboardAppearance: Brightness.light,
            // onEditingComplete: _onEditingComplete,
            // inputFormatters: <TextInputFormatter>[
            // model.emailInputFormatter,
            // ],
          ),
        ),
      ),
    );
  }
}
