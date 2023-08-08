class OrderAccept {
  String? tradeId;
  String? tradeRef;
  String? memberId;
  String? tradeType;
  int? purity;
  double? quantity;
  double? quantityBalance;
  double? price;
  double? amount;
  double? amountBalancePaid;
  String? status;
  String? createDate;
  String? paymentStatus;
  String? createBy;
  String? duedate;
  bool? leave;

  OrderAccept(
      {this.tradeId,
      this.tradeRef,
      this.memberId,
      this.tradeType,
      this.purity,
      this.quantity,
      this.quantityBalance,
      this.price,
      this.amount,
      this.amountBalancePaid,
      this.status,
      this.createDate,
      this.paymentStatus,
      this.createBy,
      this.duedate,
      this.leave});

  OrderAccept.fromJson(Map<String, dynamic> json) {
    tradeId = json['TradeId'];
    tradeRef = json['TradeRef'];
    memberId = json['MemberId'];
    tradeType = json['TradeType'];
    purity = json['Purity'];
    quantity = json['Quantity'];
    quantityBalance = json['QuantityBalance'];
    price = json['Price'];
    amount = json['Amount'];
    amountBalancePaid = json['AmountBalancePaid'];
    status = json['Status'];
    createDate = json['CreateDate'];
    paymentStatus = json['PaymentStatus'];
    createBy = json['CreateBy'];
    duedate = json['Duedate'];
    leave = json['Leave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TradeId'] = this.tradeId;
    data['TradeRef'] = this.tradeRef;
    data['MemberId'] = this.memberId;
    data['TradeType'] = this.tradeType;
    data['Purity'] = this.purity;
    data['Quantity'] = this.quantity;
    data['QuantityBalance'] = this.quantityBalance;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['AmountBalancePaid'] = this.amountBalancePaid;
    data['Status'] = this.status;
    data['CreateDate'] = this.createDate;
    data['PaymentStatus'] = this.paymentStatus;
    data['CreateBy'] = this.createBy;
    data['Duedate'] = this.duedate;
    data['Leave'] = this.leave;
    return data;
  }
}
