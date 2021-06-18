import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reward_model.dart';
import 'print_helper.dart';

///General reward helper which is shared throughout the app. Never null since it is initialized in main.
// ignore: non_constant_identifier_names
RewardHelper? REWARD_HELPER;

class RewardHelper {
  final List<RewardModel> models;
  ///The value of all the models without a state selected
  int _nationwideValue = 0;

  ///The total amount of reward money in the us.
  int _usaValue = 0;

  ///Contains all the state reward values. If the state doesn't provide any rewards, than, when searched for via state key, will return null.
  Map<String, int> _stateValues = {};

  RewardHelper(this.models) {
    _calcTotalsFromModel(models);
  }

  ///RewardHelper from a querysnapshot. Used in streams. Presets the models to zero so they can be added to later.
  RewardHelper.fromSnapshot({required QuerySnapshot<Map<String, dynamic>> snapshot}) : models = [] {
    calcAllFromSnapshot(snapshot);
  }

  void calcAllFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    try {
      Print('Refactoring snapshot data into readable fields..');

      RewardModel? model;
      Map<String, double> values = {};
      double usTotal = 0;

      Map<String, dynamic> data = {};

      snapshot.docs.forEach((element) {
        data = element.data();

        data['expirationDate'] = data['expirationDate'] != null ? data['expirationDate'].toDate() : null;
        data['uid'] = element.id;

        model = RewardModel.fromMap(data);

        //After this point MODEL IS NEVER NULL.
        this.models.add(model!);

        if (model!.reward != null && model!.state.isEmpty == false) {
          if (model!.state == 'Nationwide') {
            usTotal += model!.reward!;
          } else {
            if (values.containsKey(model!.state)) {
              values[model!.state] = model!.reward! + values[model!.state]!.toDouble();
            } else {
              values[model!.state] = model!.reward!;
            }
          }
        }

        this._stateValues = values.map((key, value) {
          return MapEntry(key, value.round());
        });

        this._nationwideValue = usTotal.round();
      });
      Print.success('All rewards from firebase have been mapped into RewardModels successfully!');
    } catch (e) {
      Print.error(e);
    }
  }


  ///Weird constructor rules in dart forced me to make this method static.
  ///I wouldn't have otherwise. Initializes _stateValues and _usTotalValue.
  void _calcTotalsFromModel(List<RewardModel> models) {
    Map<String, double> values = {};
    double nationwideTotal = 0;
    double usaValue = 0;

    models.forEach((element) {
      if (element.reward != null && element.state.isEmpty == false) {
        if (element.state == 'Nationwide') {
          nationwideTotal += element.reward!;
          usaValue += element.reward!;
        } else {
          if (values.containsKey(element.state)) {
            values[element.state] = element.reward! + values[element.state]!.toDouble();
          } else {
            values[element.state] = element.reward!;
          }

          usaValue += element.reward!;
        }
      }
    });

    this._stateValues = values.map((key, value) {
      return MapEntry(key, value.round());
    });
    this._usaValue = usaValue.round();

    this._nationwideValue = nationwideTotal.round();
    Print('This is the total us value $_nationwideValue');
  }

  Map<String, int> get stateValues => _stateValues;

  int get nationwideValue => _nationwideValue;

  int get usaValue => _usaValue;
}