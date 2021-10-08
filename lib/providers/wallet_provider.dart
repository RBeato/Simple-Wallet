import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletProvider =
    StateNotifierProvider<WalletProvider, dynamic>((ref) => WalletProvider());

class WalletProvider extends StateNotifier<Wallet> {
  WalletProvider() : super(Wallet());

  void set(Wallet wallet) {
    state = wallet;
    print("changed state: $state");
  }
}
