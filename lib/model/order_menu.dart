class OrderMenu {
  int? transId;
  String? transName;
  
  OrderMenu(
    this.transId, 
    this.transName);

  static List<OrderMenu> getOrderMenuData() {
    return <OrderMenu> [
      OrderMenu(1, 'รายการซื้อ/ขาย'),
      OrderMenu(2, 'รายการรอราคา'),
      OrderMenu(3, 'รายการยืนยันราคา'),
      OrderMenu(4, 'รายการยกเลิก'),
      OrderMenu(5, 'รายการสถานะคงค้าง'),      
    ];
  }
}