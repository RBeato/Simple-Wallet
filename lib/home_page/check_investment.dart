import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:basic_wallet/home_page/custom_button.dart';
import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences _prefs;
  WalletModel walletModel = WalletModel();
  EthereumUtils ethUtils;

  @override
  void initState() {
    super.initState();
    checkSavedValue();
  }

  checkSavedValue() async {
    _prefs = await SharedPreferences.getInstance();
    List data = _prefs.getStringList(savedBalance);
    if (data.isNotEmpty) {
      walletModel = WalletModel(
        deposited: int.parse(data[0]),
        total: int.parse(data[1]),
      );
    } else {
      walletModel = WalletModel(
        deposited: 0,
        total: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ethUtils = ref.watch(ethereumUtilsProvider);
    return Consumer(builder: (context, watch, _) {
      Widget widget;
      return FutureBuilder(
          future: ethUtils.listenContract(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = CircularProgressIndicator();
            } else if (snapshot.hasError) {
              widget = Text("Error!");
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                walletModel = WalletModel(
                    deposited: snapshot.data[0].toInt(),
                    total: snapshot.data[1].toInt());
              }
              widget = BalanceWidget(walletModel);
            }
            return widget;
          });
    });
  }
}

class BalanceWidget extends StatelessWidget {
  BalanceWidget(this.walletModel, {Key key}) : super(key: key);
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
            checkInvestmentInfoBoxText("Balance: ${walletModel.total ?? 0}"),
            checkInvestmentInfoBoxText(
                "Deposit: ${walletModel.deposited ?? 0}"),
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
