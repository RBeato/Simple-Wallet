import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletProvider =
    StateNotifierProvider<WalletProvider, dynamic>((ref) => WalletProvider());

class WalletProvider extends StateNotifier<WalletModel> {
  WalletProvider() : super(WalletModel());

  void set(WalletModel wallet) {
    state = wallet;
    print("changed state: $state");
  }
}
