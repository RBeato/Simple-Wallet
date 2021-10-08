import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/constants.dart';
import 'package:basic_wallet/models/wallet.dart';
import 'package:basic_wallet/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Check extends StatelessWidget {
  const Check({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int balance, totalDeposits;

    return Consumer(
      builder: (context, watch, _) {
        watch(walletProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Neumorphic(
                  style: NeumorphicStyle(color: Colors.white.withOpacity(0.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      checkInvestmentInfoBoxText(
                          "Balance: ${balance?.toString() ?? 0}"),
                      checkInvestmentInfoBoxText(
                          "Deposit: ${totalDeposits?.toString() ?? 0}"),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  text: "Check Investment",
                  onPressed: () async {
                    var balanceResults = await context
                        .read(ethereumUtilsProvider)
                        .readContract(Constants.getBalanceAmount, []);
                    balance = balanceResults?.first?.toInt();

                    var depositResults = await context
                        .read(ethereumUtilsProvider)
                        .readContract(Constants.getDepositAmount, []);
                    totalDeposits = depositResults.first?.toInt();

                    print("balance = $balance, totalDeposits = $totalDeposits");

                    context
                        .read(walletProvider.notifier)
                        .set(Wallet(total: balance, deposited: totalDeposits));
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Text checkInvestmentInfoBoxText(text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        //DancingScript
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
