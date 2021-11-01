import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class CheckBalances extends StatelessWidget {
  const CheckBalances({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BalanceData(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              opacity: 1.0, //
              text: "Check Investment",
              onPressed: () async {
                context.read(walletProvider).data;
              },
            ),
          ],
        ),
      ],
    );
  }
}

class BalanceData extends StatefulWidget {
  const BalanceData({Key key}) : super(key: key);

  @override
  State<BalanceData> createState() => _BalanceDataState();
}

class _BalanceDataState extends State<BalanceData> {
  WalletModel walletModel = WalletModel();

  @override
  void initState() {
    super.initState();
    getWallet();
  }

  getWallet() async {
    var balanceResult = await context
        .read(ethereumUtilsProvider)
        .readContract(Constants.getBalanceAmount, []);
    walletModel.total = balanceResult?.first?.toInt();

    var depositResult = await context
        .read(ethereumUtilsProvider)
        .readContract(Constants.getDepositAmount, []);
    walletModel.deposited = depositResult?.first?.toInt();

    print("initState balanceResult: $walletModel");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      var ethUtils = watch(ethereumUtilsProvider);

      return FutureBuilder(
          future: ethUtils.listenContract(),
          initialData: {"deposit": 0, "balance": 0},
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error!");
            } else {
              if (!snapshot.hasData) {
                return Center(child: const CircularProgressIndicator());
              }
              walletModel = WalletModel(
                  deposited: snapshot.data[1].toInt(),
                  total: snapshot.data[0].toInt());
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      checkInvestmentInfoBoxText(
                          "Balance: ${walletModel.total ?? 0}"),
                      checkInvestmentInfoBoxText(
                          "Deposit: ${walletModel.deposited ?? 0}"),
                    ],
                  ),
                ),
              );
            }
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
