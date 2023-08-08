import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:langhong/common/app_dialog.dart';
import 'package:langhong/model/order_accept.dart';
import 'package:langhong/model/order_place.dart';
import 'package:langhong/model/order_reject.dart';
import 'package:langhong/model/order_unpaid.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/model/order_trans.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ApiServices {
  //static const String domainSocket = 'http://203.151.27.223:7300';
  //static const String domainServer = 'http://203.151.27.223:99';
  //static const String domainSocket = 'http://203.154.83.60:7300';
  //static const String domainServer = 'http://203.154.83.60:7306';
  // static const String domainSocket = 'http://203.151.27.198:7790';
  static const String domainSocket = 'http://msocket.langhongonline.com:7790';

  static const String domainServer = 'http://mobileapi2.langhongonline.com';

  //-- API Login
  static Future<UserProfile?> getUserProfile(
      String userName, String passWord) async {
    try {
      UserProfile? userProfile;
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${ApiServices.domainServer}/api/User/login'));
      request.body = json.encode({"UserName": userName, "Password": passWord});
      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('statusCode= ${response.statusCode}');
      if (response.statusCode == 200) {
/*        
        var result = json.decode(response.body);
        debugPrint('(Before) result-> $result');
        debugPrint('LoginSuccess-> ${result['LoginSuccess']}');
        debugPrint('Message-> ${result['Message']}');
        debugPrint('-------------------------------');
*/
        userProfile = UserProfile.fromJson(jsonDecode(response.body));

        return userProfile;
      } else {
        return userProfile;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API get Portfolio
  static Future<UserPortfolio?> getUserPortfolio(
      String memberId, String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    try {
      UserPortfolio? userPortfolio;

      final response = await http.get(
          Uri.parse('${ApiServices.domainServer}/api/Portfolio/$memberId'),
          headers: headers);

      debugPrint('statusCode= ${response.statusCode}');
      if (response.statusCode == 200) {
/*        
        var result = json.decode(response.body);
        debugPrint('(Before) result-> $result');
        debugPrint('-------------------------------');
*/
        userPortfolio = UserPortfolio.fromJson(jsonDecode(response.body));

        return userPortfolio;
      } else {
        return userPortfolio;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API Change Username
  static Future changeUserName(
      String token, String userId, String userName) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST',
          Uri.parse('${ApiServices.domainServer}/api/user/changeusername'));
      request.body = json.encode({"UserId": userId, "username": userName});
      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('statusCode= ${response.statusCode}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      // statusCode=401 -> Token Expired
      else {
        return json.decode(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API Change Password
  static Future changePassword(
      String token, String userId, String newPassword) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST',
          Uri.parse('${ApiServices.domainServer}/api/user/changePassword'));
      request.body = json.encode({"UserId": userId, "Password": newPassword});
      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('statusCode= ${response.statusCode}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      // statusCode=401 -> Token Expired
      else {
        return json.decode(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API Trade Order
  static Future<List<OrderTrans>> getOrderTransaction(BuildContext context,
      IO.Socket socket, String memberId, String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    List<OrderTrans> orderTransList;
    try {
      orderTransList = [];
      debugPrint('---> Call getOrderTransaction() --------');
      final response = await http.get(
          Uri.parse(
              '$domainServer/api/OrderMemberType?MemberId=$memberId&Type=Order'),
          headers: headers);

      debugPrint('StatusCode= ${response.statusCode}');
      debugPrint('---------------------------------------');
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        List<dynamic> data = result;
        orderTransList =
            data.map((value) => OrderTrans.fromJson(value)).toList();
        return orderTransList;
      } else if (response.statusCode == 401) {
        AppDialog.refreshLoginDialog(
            context, socket, 2, 'Session Expired/เซสชั่นหมดอายุ');
        return orderTransList;
      } else if (response.statusCode == 400) {
        AppDialog.refreshLoginDialog(context, socket, 2, 'API not found');
        return orderTransList;
      } else {
        AppDialog.refreshLoginDialog(context, socket, 2, 'server error');
        return orderTransList;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API Place Trade Order
  static Future<List<OrderPlace>> getOrderPlaceTransaction(BuildContext context,
      IO.Socket socket, String memberId, String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    List<OrderPlace> orderPlaceList;
    try {
      orderPlaceList = [];
      debugPrint('---> Call getOrderPlaceTransaction() --------');
      final response = await http.get(
          Uri.parse(
              '$domainServer/api/OrderMemberType?MemberId=$memberId&Type=Place'),
          headers: headers);

      debugPrint('StatusCode= ${response.statusCode}');
      debugPrint('---------------------------------------');
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        List<dynamic> data = result;
        orderPlaceList = data.map((item) => OrderPlace.fromJson(item)).toList();
        return orderPlaceList;
      } else if (response.statusCode == 401) {
        AppDialog.refreshLoginDialog(
            context, socket, 2, 'Session Expired/เซสชั่นหมดอายุ');
        return orderPlaceList;
      } else if (response.statusCode == 400) {
        AppDialog.refreshLoginDialog(context, socket, 2, 'API not found');
        return orderPlaceList;
      } else {
        AppDialog.refreshLoginDialog(context, socket, 2, 'server error');
        return orderPlaceList;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<OrderReject>> getOrderRejectTransaction(
      BuildContext context,
      IO.Socket socket,
      String memberId,
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    List<OrderReject> orderRejectList;
    try {
      orderRejectList = [];
      debugPrint('---> Call getOrderRejectTransaction() --------');
      final response = await http.get(
          Uri.parse(
              '$domainServer/api/OrderMemberType?MemberId=$memberId&Type=Reject'),
          headers: headers);

      debugPrint('StatusCode= ${response.statusCode}');
      debugPrint('---------------------------------------');
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        List<dynamic> data = result;
        orderRejectList =
            data.map((item) => OrderReject.fromJson(item)).toList();
        return orderRejectList;
      } else if (response.statusCode == 401) {
        AppDialog.refreshLoginDialog(
            context, socket, 2, 'Session Expired/เซสชั่นหมดอายุ');
        return orderRejectList;
      } else if (response.statusCode == 400) {
        AppDialog.refreshLoginDialog(context, socket, 2, 'API not found');
        return orderRejectList;
      } else {
        AppDialog.refreshLoginDialog(context, socket, 2, 'server error');
        return orderRejectList;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API Reject Trade Order
  static Future rejectTradeOrder(String tradeId, String token) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('${ApiServices.domainServer}/api/Reject'));
      request.body = json.encode({"TradeId": tradeId});
      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('statusCode= ${response.statusCode}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null; // statusCode=401 -> Token Expired
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API Accept Trade Order
  static Future<List<OrderAccept>> getOrderAcceptTransaction(
      BuildContext context,
      IO.Socket socket,
      String memberId,
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    List<OrderAccept> orderAcceptList;
    try {
      orderAcceptList = [];
      debugPrint('---> Call getOrderAcceptTransaction() --------');
      final response = await http.get(
          Uri.parse(
              '$domainServer/api/OrderMemberType?MemberId=$memberId&Type=Accept'),
          headers: headers);

      debugPrint('StatusCode= ${response.statusCode}');
      debugPrint('---------------------------------------');
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        List<dynamic> data = result;
        orderAcceptList =
            data.map((item) => OrderAccept.fromJson(item)).toList();
        return orderAcceptList;
      } else if (response.statusCode == 401) {
        AppDialog.refreshLoginDialog(
            context, socket, 2, 'Session Expired/เซสชั่นหมดอายุ');
        return orderAcceptList;
      } else if (response.statusCode == 400) {
        AppDialog.refreshLoginDialog(context, socket, 2, 'API not found');
        return orderAcceptList;
      } else {
        AppDialog.refreshLoginDialog(context, socket, 2, 'server error');
        return orderAcceptList;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //-- API Unpaid Trade Order
  static Future<List<OrderUnpaid>> getOrderUnpaidTransaction(
      BuildContext context,
      IO.Socket socket,
      String memberId,
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    List<OrderUnpaid> orderUnpaidList;
    try {
      orderUnpaidList = [];
      debugPrint('---> Call getOrderUnpaidTransaction() --------');
      final response = await http.get(
          Uri.parse(
              '$domainServer/api/OrderMemberType?MemberId=$memberId&Type=Unpaid'),
          headers: headers);

      debugPrint('StatusCode= ${response.statusCode}');
      debugPrint('---------------------------------------');
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        List<dynamic> data = result;
        orderUnpaidList =
            data.map((item) => OrderUnpaid.fromJson(item)).toList();
        return orderUnpaidList;
      }
      // statusCode=401 -> Token Expired
      else if (response.statusCode == 401) {
        AppDialog.refreshLoginDialog(
            context, socket, 2, 'Session Expired/เซสชั่นหมดอายุ');
        return orderUnpaidList;
      } else if (response.statusCode == 400) {
        AppDialog.refreshLoginDialog(context, socket, 2, 'API not found');
        return orderUnpaidList;
      } else {
        AppDialog.refreshLoginDialog(context, socket, 2, 'server error');
        return orderUnpaidList;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
