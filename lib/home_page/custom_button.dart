import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key key, this.onPressed, this.text, this.opacity})
      : super(key: key);

  final Function onPressed;
  final String text;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: opacity,
        child: ElevatedButton(
          child: Text(text),
          onPressed: onPressed,
        ),
      ),
    );

    // NeumorphicButton(
    //     margin: EdgeInsets.only(top: 15),
    //     onPressed: onPressed,
    //     style: NeumorphicStyle(
    //       shape: NeumorphicShape.flat,
    //       boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
    //       border: NeumorphicBorder(color: Colors.white.withOpacity(0.2)),
    //       color: Colors.white.withOpacity(0.05),
    //     ),
    //     padding: const EdgeInsets.all(12.0),
    //     child: Text(text,
    //         style: GoogleFonts.openSans(
    //             //DancingScript
    //             color: Colors.white,
    //             fontSize: 18.0,
    //             fontWeight: FontWeight.w300,
    //             shadows: [
    //               Shadow(
    //                 offset: Offset(0.0, 3.0),
    //                 blurRadius: 10.0,
    //                 color: Color.fromARGB(255, 0, 0, 0),
    //               ),
    //             ])));
  }
}
