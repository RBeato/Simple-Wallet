import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

final walletProvider = FutureProvider((ref) async {
  var balanceResult = await ref
      .watch(ethereumUtilsProvider)
      .readContract(Constants.getBalanceAmount, []);
  int balance = balanceResult?.first?.toInt();

  var depositResult = await ref
      .watch(ethereumUtilsProvider)
      .readContract(Constants.getDepositAmount, []);
  int totalDeposit = depositResult.first?.toInt();

  return WalletModel(deposited: totalDeposit, total: balance);
});

// final walletProvider =
//     StateNotifierProvider<WalletProvider, dynamic>((ref) => WalletProvider());

// class WalletProvider extends StateNotifier<WalletModel> {
//   WalletProvider() : super(WalletModel());

//   void set(WalletModel wallet) {
//     state = wallet;
//     print("wallet changed state: $state");
//   }
// }

class WalletModel {
  WalletModel({
    this.total,
    this.deposited,
  });

  int total = 0;
  int deposited = 0;

  @override
  String toString() {
    return "Total value with interest: $total, from $deposited deposited";
  }
}
