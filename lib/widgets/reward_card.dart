import 'package:flutter/material.dart';
import 'package:shared_vaccination/models/reward_model.dart';
import 'animations/build_animations.dart';
import 'package:shared_vaccination/constants.dart' as con;

class RewardCard extends StatelessWidget {
  final RewardModel model;
  final Color color;
  final Color borderColor;
  final int index;
  final GestureTapCallback? onPressed;

  RewardCard({required this.model, required this.color, required this.borderColor, required this.index,  this.onPressed});

  RewardCard.red({required this.model, required this.index, this.onPressed})
      : this.color = Color(0xFFB22234), //Color(0xFFFFB1BC),
        this.borderColor = Colors.white;
  //this.borderColor = Color(0xFFC62828);

  RewardCard.green({required this.model, required this.index, this.onPressed})
      : this.color = Color(0xFF3C3B6F), //Color(0xFF9AC9FD)
        this.borderColor = Colors.white;
  //this.borderColor = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    if(model.hasExpired()){
      return _getCard(context, Colors.grey[400]!, Colors.grey[600]!);
    }

    return _getCard(context, color, borderColor);
  }

  Widget _getCard(BuildContext context, Color color, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(con.kMediumSpacing, 3, con.kMediumSpacing, 0),
              child: FadeInBuild(
                duration: Duration(milliseconds: 700),
                child: Card(
                  color: color,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    //side: BorderSide(width: 0, color: this.borderColor)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: con.kBoldHeader1,
                            children: <TextSpan>[
                              TextSpan(text: this.model.provider, style: TextStyle(color: borderColor)),
                              this.model.reward != null ? TextSpan(text: this.model.getEstimate(), style: TextStyle(fontSize: 12, color: borderColor)) : TextSpan(text: ''),
                              // TextSpan(text: 'for nationwide deals', style:  TextStyle(color: Colors.black, decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: con.kMediumSpacing,
                        ),
                        Text(this.model.description, style: TextStyle(fontSize: 12, color: borderColor)),
                        Text(this.model.expirationDate == null ? 'There is no expiration date for this reward' : 'Reward expires in ${this.model.daysToExpiration()} days', style: TextStyle(fontSize: 12, color: borderColor),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            onTap: onPressed,
        )
      ],
    );
  }
}
