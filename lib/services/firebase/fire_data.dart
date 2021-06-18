
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_vaccination/models/reward_model.dart';
import 'package:shared_vaccination/util/print_helper.dart';
import 'package:shared_vaccination/util/result.dart';
import 'package:shared_vaccination/util/reward_helper.dart';

class RewardData {
  static CollectionReference _rewardsReference = FirebaseFirestore.instance.collection('rewardInfo');

  @deprecated
  ///Soon to be removed and switched out with the new stream method.
  static Future<List<RewardModel>> getAllRewards() async{
    try {
      QuerySnapshot snapshot = await _rewardsReference.get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      List<RewardModel> rewards = [];
      Map<String, dynamic> map = {};

      docs.forEach((element) {
        Print('Getting doc with provider of ${(element.data() as Map<String, dynamic>)['provider']}');
        map = element.data() as Map<String, dynamic>;
        map['uid'] = element.id;
        map['expirationDate'] = map['expirationDate'] != null ? (map['expirationDate'] as Timestamp).toDate() : null;

        rewards.add(RewardModel.fromMap(map));
      });

      return rewards;
    }catch (e){
      Print.error(e);
      return [];
    }
  }


  ///Edits the provided Reward in the database. If it doesn't exit, it adds a new one.
  static Future<Result> editReward(RewardModel model) async{
    try{
      if(model.uid != '-1') {
        await _rewardsReference.doc(model.toMap()['uid']).set(model.toMap()..remove('uid'));
      }else{
        Print.debug('Uid is equal to one therefore adding a new value to the database');
        await _rewardsReference.doc().set(model.toMap()..remove('uid'));
      }

      return Result(code: ResultCode.SUCCESS);
    } catch (e){
      Print.error(e);
      return Result(code: ResultCode.ERROR, message: 'Reward Editing failed');
    }
  }

  static Future<Result> removeReward(String uid) async{
    try{
      await _rewardsReference.doc(uid).delete();

      return Result(code: ResultCode.SUCCESS);
    }catch  (e){
      return Result(code: ResultCode.ERROR, message: 'Reward removing failed');
    }
  }


  ///Reward helper stream. I made this as efficient as I new how, but I do want it to be a little more efficient than what we have now.
  static Stream<RewardHelper> get rewardHelper{
    return _rewardsReference.snapshots().map((event) => RewardHelper.fromSnapshot(snapshot: event as QuerySnapshot<Map<String, dynamic>>));
  }
}

@deprecated
class FireDataTransportation {


  Future<void> transferDataBack() async{
    CollectionReference rewardInfo = FirebaseFirestore.instance.collection('rewardInfo');
    List<QueryDocumentSnapshot> docs = await rewardInfo.get().then((value) => value.docs);
    Map<String,dynamic> adjustedData = {};

    docs.forEach((element) async{
      adjustedData = element.data() as Map<String ,dynamic>;

      adjustedData['expirationDate'] = null;
      adjustedData['uid'] = element.id;

      await rewardInfo.add(adjustedData);
    });
  }

// ///Transports the data to the newly created section rewardData.
// Future<void> transportToNewSection() async{
//   CollectionReference rewardsReference = FirebaseFirestore.instance.collection('rewardInfo');
//   CollectionReference newReference = FirebaseFirestore.instance.collection('rewardData').doc('rewards').collection('models');
//   Map<String, dynamic> map = {};
//   QuerySnapshot snapshot = await rewardsReference.get();
//   List<QueryDocumentSnapshot> docs = snapshot.docs;
//
//   Print.debug('Starting transportation process');
//   Print.debug('Adding ${docs.length} to the new section...');
//
//   docs.forEach((element) async{
//     Print('Adding the following element ${(element.data() as Map<String, dynamic>)['provider']}');
//     map = element.data() as Map<String, dynamic>;
//     map['expirationDate'] = null;
//
//     await newReference.doc().set((map));
//   });
//
//   Print.debug('Completed with ${(await newReference.get()).docs.length}');
//   Print.success('Done');
// }

// Future<void> addToDatabase() async {
//   String json = await loadJson();
//   List<dynamic> list = jsonDecode(json);
//   Map<String, dynamic> map = {};
//   CollectionReference rewardReference = FirebaseFirestore.instance.collection('rewardInfo');
//
//   for (int i = 0; i < list.length; i++) {
//     map = formattedData(list[i]);
//     Print('Adding map with the following provider ${map['provider']}');
//     await rewardReference.doc().set(map);
//   }
//   Print.success('Done');
// }
//
// Map<String, dynamic> formattedData(Map<String, dynamic> map) {
//   double? reward = reformatRewardStrings(map['value']);
//
//   if(reward == -1) {
//     Print.debug('Formatting failed. Provider: ${map['Title']}, value: ${map['value']}');
//   }
//
//   return {
//     'provider': map['Title'],
//     'link': map['link'],
//     'description': map['Description'],
//     'reward': reward,
//     'city': map['City'],
//     'state': map['State'],
//     'visible' : true,
//   };
// }
//
// double? reformatRewardStrings(String? reward){
//   double formattedReward = -1;
//   if(reward == null || reward.isEmpty) {
//     return null;
//   }
//
//   reward = reward.replaceFirst('\$', '', 0);
//
//   try{
//     formattedReward = double.parse(reward);
//     return formattedReward;
//   }on FormatException {
//     return -1;
//   }
// }
//
// Future<String> loadJson() async {
//   return await rootBundle.loadString('assets/reward_data.json');
// }

}
