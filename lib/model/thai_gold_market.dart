class ThaiGoldMarket {
  String? status;
  Response? response;

  ThaiGoldMarket({this.status, this.response});

  ThaiGoldMarket.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? date;
  String? updateTime;
  Price? price;

  Response({this.date, this.updateTime, this.price});

  Response.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    updateTime = json['update_time'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['update_time'] = this.updateTime;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    return data;
  }
}

class Price {
  Gold? gold;
  Gold? goldBar;

  Price({this.gold, this.goldBar});

  Price.fromJson(Map<String, dynamic> json) {
    gold = json['gold'] != null ? new Gold.fromJson(json['gold']) : null;
    goldBar =
        json['gold_bar'] != null ? new Gold.fromJson(json['gold_bar']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gold != null) {
      data['gold'] = this.gold!.toJson();
    }
    if (this.goldBar != null) {
      data['gold_bar'] = this.goldBar!.toJson();
    }
    return data;
  }
}

class Gold {
  String? buy;
  String? sell;

  Gold({this.buy, this.sell});

  Gold.fromJson(Map<String, dynamic> json) {
    buy = json['buy'];
    sell = json['sell'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buy'] = this.buy;
    data['sell'] = this.sell;
    return data;
  }
}


List<ThaiGoldMarket> thaiGoldMarketList = [];