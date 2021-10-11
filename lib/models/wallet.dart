import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletProvider =
    StateNotifierProvider<WalletProvider, dynamic>((ref) => WalletProvider());

class WalletProvider extends StateNotifier<WalletModel> {
  WalletProvider() : super(WalletModel());

  void set(WalletModel wallet) {
    state = wallet;
    print("wallet changed state: $state");
  }
}

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
