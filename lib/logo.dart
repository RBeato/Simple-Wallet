import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 180.0,
            child: Image.asset(
              'assets/images/eth_wallet.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: 6.1,
              child: Text("Basic Wallet!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                      //DancingScript
                      color: Colors.white,
                      fontSize: 60.0,
                      fontWeight: FontWeight.w300,
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 3.0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ])),
            ))
      ],
    );
  }
}
