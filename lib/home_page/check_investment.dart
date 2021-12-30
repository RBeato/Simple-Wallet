import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckBalances extends StatelessWidget {
  const CheckBalances({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BalanceData(),
      ],
    );
  }
}

class BalanceData extends ConsumerStatefulWidget {
  const BalanceData({Key key}) : super(key: key);

  @override
  _BalanceDataState createState() => _BalanceDataState();
}

class _BalanceDataState extends ConsumerState<BalanceData> {
  Future balanceFuture;
  WalletModel walletModel = WalletModel();
  EthereumUtils ethUtils;

  @override
  void initState() {
    super.initState();
    // ethUtils = ref.read(ethereumUtilsProvider);
    // futureBuilder info video: https://www.youtube.com/watch?v=LYN46233cws
  }

  @override
  Widget build(BuildContext context) {
    ethUtils = ref.watch(ethereumUtilsProvider);
    return Consumer(builder: (context, watch, _) {
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
                print("BalanceData $walletModel");
                return Center(child: const Text("No data yet!"));
              }
              walletModel.deposited = snapshot.data[0].toInt();
              walletModel.total = snapshot.data[1].toInt();

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
