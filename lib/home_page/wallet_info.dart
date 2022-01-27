import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletInfo extends ConsumerStatefulWidget {
  const WalletInfo({Key? key}) : super(key: key);

  @override
  _WalletInfoState createState() => _WalletInfoState();
}

class _WalletInfoState extends ConsumerState<WalletInfo> {
  late SharedPreferences _prefs;
  late WalletModel? walletModel;
  late EthereumUtils ethUtils;

  @override
  void initState() {
    super.initState();
    checkSavedValue();
  }

  checkSavedValue() async {
    _prefs = await SharedPreferences.getInstance();
    List? data = _prefs.getStringList(savedBalance);
    if (data != null && data.isNotEmpty) {
      walletModel = WalletModel(
        deposited: int.parse(data[0]),
        balance: int.parse(data[1]),
      );
    } else {
      walletModel = WalletModel(
        deposited: 0,
        balance: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ethUtils = ref.watch(ethereumUtilsProvider);
    return Consumer(builder: (context, watch, _) {
      late Widget widget = Container(child: Text("No data!"));
      return FutureBuilder(
          future: ethUtils.listenContract(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = CircularProgressIndicator();
            } else if (snapshot.hasError) {
              widget = Text("Error!");
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                List? data = snapshot.data as List;

                walletModel = WalletModel(
                    deposited: data[0].toInt(), balance: data[1].toInt());
              }
              widget = BalanceWidget(walletModel!);
            }
            return widget;
          });
    });
  }
}

class BalanceWidget extends StatelessWidget {
  BalanceWidget(this.walletModel, {Key? key}) : super(key: key);
  final WalletModel walletModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            checkInvestmentInfoBoxText("Balance: ${walletModel.balance}"),
            checkInvestmentInfoBoxText(
                "Last Deposit: ${walletModel.deposited}"),
          ],
        ),
      ),
    );
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
