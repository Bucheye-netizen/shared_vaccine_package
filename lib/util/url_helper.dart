import 'package:shared_vaccination/util/print_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper{
  static Future<bool> launchURL(String url) async{
    bool launchable = await canLaunch(url);

    if(launchable) {
      Print('Launching provided url...');
      bool isSuccessful = await launch(url);
      isSuccessful ? Print.success('Launch succeeded') : Print.fail('Url Launch failed');
      return isSuccessful;
    }else{
      Print.error('This url cannot be launched');
      return false;
    }
  }
}