class UserPortfolio {
  UserPortfolio(
      {this.memberId,
      this.memberRef,
      this.memberType,
      this.memberGroup,
      this.memberTitle,
      this.memberLevel,
      this.firstName,
      this.lastName,
      this.email,
      this.duedateValue,
      this.freeMargin,
      this.maxKg,
      this.maxBg,
      this.creditLimit,
      this.creditLimitBg,
      this.marginStatus,
      this.marginValue,
      this.marginValueBg,
      this.creditLine,
      this.creditLineBuy,
      this.creditLineSel,
      this.creditLineBg,
      this.creditLineBgBuy,
      this.creditLineBgSel,
      this.creditBuyBalance,
      this.creditBuyBalanceBg,
      this.creditSellBalance,
      this.creditSellBalanceBg,
      this.sumBuyPlaceOrder,
      this.sumBuyPlaceOrderBg,
      this.sumSellPlaceOrder,
      this.sumSellPlaceOrderBg,
      this.sumBuy,
      this.sumBuyBg,
      this.sumSell,
      this.sumSellBg,
      this.assetCash,
      this.assetGold,
      this.assetGoldBg,
      this.maintenanceMarginCash,
      this.maintenanceMarginGold,
      this.maintenanceMarginGoldBg,
      this.depositGold,
      this.depositGoldBg,
      this.pauseBuy,
      this.pauseSell,
      this.withdrawAble,
      this.assetTradeAble,
      this.assetTradeAbleCallForce,
      this.assetTradeAbleMaintenanceMargin,
      this.assetTradeAbleBuy,
      this.assetTradeAbleSell,
      this.quantityBalanceSellGoldDep,
      this.ticketPendingList,
      this.ticketCompleteList,
      this.transferList,
      this.ticketSplitBalance,
      this.messageWarning,
      this.onlineStatus});

  String? memberId;
  String? memberRef;
  String? memberType;
  String? memberGroup;
  String? memberTitle;
  String? memberLevel;
  String? firstName;
  String? lastName;
  String? email;
  double? duedateValue;
  double? freeMargin;
  double? maxKg;
  double? maxBg;
  double? creditLimit;
  double? creditLimitBg;
  String? marginStatus;
  double? marginValue;
  double? marginValueBg;
  double? creditLine;
  double? creditLineBuy;
  double? creditLineSel;
  double? creditLineBg;
  double? creditLineBgBuy;
  double? creditLineBgSel;
  double? creditBuyBalance;
  double? creditBuyBalanceBg;
  double? creditSellBalance;
  double? creditSellBalanceBg;
  double? sumBuyPlaceOrder;
  double? sumBuyPlaceOrderBg;
  double? sumSellPlaceOrder;
  double? sumSellPlaceOrderBg;
  double? sumBuy;
  double? sumBuyBg;
  double? sumSell;
  double? sumSellBg;
  double? assetCash;
  double? assetGold;
  double? assetGoldBg;
  double? maintenanceMarginCash;
  double? maintenanceMarginGold;
  double? maintenanceMarginGoldBg;
  double? depositGold;
  double? depositGoldBg;
  bool? pauseBuy;
  bool? pauseSell;
  bool? withdrawAble;
  double? assetTradeAble;
  double? assetTradeAbleCallForce;
  double? assetTradeAbleMaintenanceMargin;
  double? assetTradeAbleBuy;
  double? assetTradeAbleSell;
  double? quantityBalanceSellGoldDep;
  String? ticketPendingList;
  String? ticketCompleteList;
  String? transferList;
  String? ticketSplitBalance;
  String? messageWarning;
  String? onlineStatus;

  factory UserPortfolio.fromJson(Map<String, dynamic> json) {
    return UserPortfolio(    
      memberId: json['MemberId'],
      memberRef:json['MemberRef'],
      memberType: json['MemberType'],
      memberGroup: json['MemberGroup'],
      memberTitle: json['MemberTitle'],
      memberLevel: json['MemberLevel'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      email: json['Email'],
      duedateValue: json['DuedateValue'],
      freeMargin: json['FreeMargin'],
      maxKg: json['MaxKg'],
      maxBg: json['MaxBg'],
      creditLimit: json['CreditLimit'],
      creditLimitBg: json['CreditLimitBg'],
      marginStatus: json['MarginStatus'],
      marginValue: json['MarginValue'],
      marginValueBg: json['MarginValueBg'],
      creditLine: json['CreditLine'],
      creditLineBuy: json['CreditLineBuy'],
      creditLineSel: json['CreditLineSel'],
      creditLineBg: json['CreditLineBg'],
      creditLineBgBuy: json['CreditLineBgBuy'],
      creditLineBgSel: json['CreditLineBgSel'],
      creditBuyBalance: json['CreditBuyBalance'],
      creditBuyBalanceBg: json['CreditBuyBalanceBg'],
      creditSellBalance: json['CreditSellBalance'],
      creditSellBalanceBg: json['CreditSellBalanceBg'],
      sumBuyPlaceOrder: json['SumBuyPlaceOrder'],
      sumBuyPlaceOrderBg: json['SumBuyPlaceOrderBg'],
      sumSellPlaceOrder: json['SumSellPlaceOrder'],
      sumSellPlaceOrderBg: json['SumSellPlaceOrderBg'],
      sumBuy: json['SumBuy'],
      sumBuyBg: json['SumBuyBg'],
      sumSell: json['SumSell'],
      sumSellBg: json['SumSellBg'],
      assetCash: json['AssetCash'],
      assetGold: json['AssetGold'],
      assetGoldBg: json['AssetGoldBg'],
      maintenanceMarginCash: json['MaintenanceMarginCash'],
      maintenanceMarginGold: json['MaintenanceMarginGold'],
      maintenanceMarginGoldBg: json['MaintenanceMarginGoldBg'],
      depositGold: json['DepositGold'],
      depositGoldBg: json['DepositGoldBg'],
      pauseBuy: json['PauseBuy'],
      pauseSell: json['PauseSell'],
      withdrawAble: json['WithdrawAble'],
      assetTradeAble: json['AssetTradeAble'],
      assetTradeAbleCallForce: json['AssetTradeAbleCallForce'],
      assetTradeAbleMaintenanceMargin: json['AssetTradeAbleMaintenanceMargin'],
      assetTradeAbleBuy: json['AssetTradeAbleBuy'],
      assetTradeAbleSell: json['AssetTradeAbleSell'],
      quantityBalanceSellGoldDep: json['QuantityBalanceSellGoldDep'],
      ticketPendingList: json['TicketPendingList'],
      ticketCompleteList: json['TicketCompleteList'],
      transferList: json['TransferList'],
      ticketSplitBalance: json['TicketSplitBalance'],
      messageWarning: json['MessageWarning'],
      onlineStatus: json['OnlineStatus'],
    );
  }

}