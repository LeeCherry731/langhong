import 'package:get/get.dart';
import 'package:langhong/api/api_services.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';

class MainCtr extends GetxController {
  final userProfileList = UserProfile().obs;
  final userPortfolioList = UserPortfolio().obs;
  final marketPriceList = <MarketPrice>[].obs;

  // ApiServices.getUserProfile(userName.text, passWord.text)

  void getPortfolio() async {
    await ApiServices.getUserPortfolio(userProfileList.value.memberId!,
            userProfileList.value.accessToken ?? "")
        .then((value) {
      userPortfolioList.value = value ?? UserPortfolio();
    });
  }
}
