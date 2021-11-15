import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3dart/credentials.dart';

class CheckBalances extends StatelessWidget {
  const CheckBalances({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BalanceData(),
        EventData(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              opacity: 1.0, //
              text: "Check Investment",
              onPressed: () async {
                // context.read(walletProvider).data;
                //replace with
                //setState{()}
              },
            ),
          ],
        ),
      ],
    );
  }
}

class EventData extends StatelessWidget {
  const EventData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Event Data"),
      Consumer(builder: (context, watch, _) {
        var ethUtils = watch(ethereumUtilsProvider);
        return FutureBuilder(
            future: ethUtils.listenContract(),
            initialData: WalletModel(deposited: 5, total: 5),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading....');
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    return Text('Result: ${snapshot.data}');
              }
            });
      })
    ]);
  }
}

//! tRY to listen to the events, if it comes null call the balance directly. if (!hasData) fetchBalance()

class BalanceData extends StatelessWidget {
  const BalanceData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      var walletPrvdr = watch(walletProvider);
      return walletPrvdr.when(
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text(error.toString()),
          data: (data) {
            WalletModel wallet = data as WalletModel;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Text(data.runtimeType.toString())
                    checkInvestmentInfoBoxText("Balance: ${wallet.total ?? 0}"),
                    checkInvestmentInfoBoxText(
                        "Deposit: ${wallet.deposited ?? 0}"),
                  ],
                ),
              ),
            );
          });
    });
  }

  Text checkInvestmentInfoBoxText(text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        color: Colors.black26.withOpacity(0.4),
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(
            offset: Offset(0.0, 6.0),
            blurRadius: 6.0,
            color: Colors.white30.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
