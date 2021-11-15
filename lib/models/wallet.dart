import 'package:basic_wallet/blockchain_utils/ethereum_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

final walletProvider = FutureProvider((ref) async {
  WalletModel wallet;

  await ref.watch(ethereumUtilsProvider).listenContract().then((decoded) {
    wallet = decoded;
  });

  getWallet() async {
    final balanceResult = await ref
        .watch(ethereumUtilsProvider)
        .readContract(Constants.getBalanceAmount, []);
    int balance = balanceResult?.first?.toInt();

    final depositResult = await ref
        .watch(ethereumUtilsProvider)
        .readContract(Constants.getDepositAmount, []);
    int totalDeposit = depositResult.first?.toInt();

    return WalletModel(deposited: totalDeposit, total: balance);
  }

  return wallet ?? getWallet();
});

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
