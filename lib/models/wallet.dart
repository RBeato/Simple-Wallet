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
