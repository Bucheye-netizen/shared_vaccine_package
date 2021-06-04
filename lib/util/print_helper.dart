
import 'package:ansicolor/ansicolor.dart';

///This class that colorizes print statements using a package so I can view it better in the console.
class Print {
  static AnsiPen _pen = AnsiPen();

  Print(Object text) {
    _pen
      ..reset()
      ..cyan(bold: false);
    print(_pen(text));
  }


  Print.error(Object text){
    _pen
      ..reset()
      ..red(bold: false);
    print(_pen(text));
  }


  Print.warning(Object text){
    _pen
      ..reset()
      ..yellow(bold: false);
    print(_pen(text));
  }


  Print.success(Object text){
    _pen
      ..reset()
      ..green(bold: false);
    print(_pen(text));
  }

  ///This is only deprecated so that I don't accidentally leave print statemtns lying everywhere.
  @deprecated
  Print.debug(Object text){
    _pen
      ..reset()
      ..xterm(129);
    print(_pen(text));
  }

  Print.fail(Object text){
    _pen
      ..reset()
      ..red(bold: false);
    print(_pen(text));
  }
}
