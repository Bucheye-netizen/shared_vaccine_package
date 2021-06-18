import 'package:cloud_firestore/cloud_firestore.dart';

class RewardModel {
  final String? link;

  ///Unfortunately, the provided spreadsheet forces us to use a String format for the monetary rewards. bummer
  final double? reward;

  ///The person who provides the rewards
  final String provider;
  final String description;
  final String state;
  final String? city;

  final String _uid;
  final DateTime? expirationDate;

  RewardModel(
      {required this.link,
        this.reward,
        required this.provider,
        required this.description,
        required this.state,
        this.city,
        required String uid,
        required this.expirationDate})
      : this._uid = uid;

  RewardModel.fromMap(Map<String, dynamic> map)
      : this.link = map['link'],
        this.reward = double.tryParse(map['reward'].toString()),
        this.provider = map['provider'],
        this.description = map['description'],
        this.state = map['state'],
        this._uid = map['uid'],
        this.city = map['city'],
        this.expirationDate = map['expirationDate'];

  ///Gets the title for the cards which display this information.
  String getTitle() {
    String title = '';

    if (reward != null) {
      title = reward != null ? '$provider - ${_formatDoubleToMonetary(this.reward!)} Estimated Value' : provider;
    } else {
      title = '$provider';
    }
    return title;
  }

  String getEstimate() {
    String title = '';
    title = ' - ${_formatDoubleToMonetary(this.reward!)} Estimated Value';
    return title;
  }

  ///Reformats the reward to make it easier for human eyes(eg: adds commas and dollar signs).
  String _formatDoubleToMonetary(double price) {
    String formattedPrice;
    int afterDecimal = 0;

    if (price > 1000000) {
      afterDecimal = ((price - price.truncateToDouble()) * 100).round();

      if (afterDecimal.toString().length == 1) {
        return formattedPrice = '\$${(price / 1000000).round()} million';
      }

      formattedPrice = '\$${(price / 1000000)} million';
    } else {
      afterDecimal = ((price - price.truncateToDouble()) * 100).round();

      if (afterDecimal.toString().length == 1) {
        return formattedPrice = '\$${price.truncate()}';
      }
      formattedPrice = '\$${price.truncate()}.$afterDecimal';
    }
    return formattedPrice;
  }

  String get uid => _uid;

  Map<String, dynamic> toMap() {
    return {
      'link': link,
      'reward': reward,
      'provider': provider,
      'description': description,
      'state': state,
      'city': city,
      'uid': _uid,
      'expirationDate': expirationDate != null ? Timestamp.fromDate(expirationDate!) : null,
    };
  }

  bool hasExpired(){
    if(expirationDate == null) {
      return false;
    }

    return expirationDate!.isBefore(DateTime.now());
  }

  int daysToExpiration(){
    if(expirationDate == null){
      return -1;
    }else{
      if(hasExpired()){
        return 0;
      }else{
        Duration duration = expirationDate!.difference(DateTime.now());
        return duration.inDays;
      }
    }
  }
}
