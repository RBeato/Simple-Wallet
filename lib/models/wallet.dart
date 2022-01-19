class WalletModel {
  WalletModel({
    required this.balance,
    required this.deposited,
  });

  int balance = 0;
  int deposited = 0;

  @override
  String toString() {
    return "Total value with interest: $balance, from $deposited deposited";
  }
}
