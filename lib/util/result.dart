
import 'package:shared_vaccination/util/print_helper.dart';

///A class for method results(eg: did the succeed, if they didn't what was their error message etcetra).
class Result{
  final String message;
  final ResultCode code;
  final Exception? error;

  Result({this.message = '', required this.code, this.error});

  void printError() {
    if(error != null) {
      Print.error(error!);
    }else{
      Print.fail('No error has been provided to this result');
    }
  }
}

enum ResultCode{
  ///Used when the code was successful.
  SUCCESS,
  ///Used when the program fails. Example: a sign up call failing because of a misshapen email would have this value.
  FAIL,
  ///Used when the program encounters an error.
  ERROR,
  ///Used when it is unknown whether the code has succeeded or not.
  INCONCLUSIVE,
}