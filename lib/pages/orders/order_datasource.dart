import 'package:flutter/material.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/model/order_trans.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OrderDataSource extends DataGridSource {
  //var integer = NumberFormat('#,##0', 'en_US');
  //var decimal = NumberFormat('#,##0.00', 'en_US');
  /// Creates the employee data source class with required details.
  OrderDataSource({required List<OrderTrans> orderData}) {
    _orderData = orderData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'tradeRef', value: e.tradeRef),
              DataGridCell<String>(columnName: 'tradeType', value: e.tradeType),
              DataGridCell<int>(columnName: 'purity', value: e.purity),
              DataGridCell<double>(columnName: 'quantity', value: e.quantity),
              DataGridCell<double>(
                  columnName: 'quantityBalance', value: e.quantityBalance),
              DataGridCell<double>(columnName: 'price', value: e.price),
              DataGridCell<double>(columnName: 'amount', value: e.amount),
              DataGridCell<double>(
                  columnName: 'amountBalancePaid', value: e.amountBalancePaid),
              DataGridCell<String>(columnName: 'status', value: e.status),
              DataGridCell<String>(
                  columnName: 'createDate', value: e.createDate),
              DataGridCell<String>(
                  columnName: 'paymentStatus', value: e.paymentStatus),
              DataGridCell<String>(columnName: 'createBy', value: e.createBy),
              DataGridCell<String>(columnName: 'duedate', value: e.duedate),
            ]))
        .toList();
  }

  List<DataGridRow> _orderData = [];

  @override
  List<DataGridRow> get rows => _orderData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5.0),
          child: Text(e.value.toString(), style: AppFont.bodyText06),
        );
    }).toList());
  }
}