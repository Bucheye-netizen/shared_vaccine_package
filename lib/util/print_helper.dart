import 'package:ansicolor/ansicolor.dart';

///This class that colorizes print statements using a package so I can view it better in the console.
class Print {
  static AnsiPen _pen = AnsiPen();
  static Map<String, PrintChannel> _channels = {
    'debug': PrintChannel(channel: 'debug', isEnabled: true, subChannels: {
      'shared' : SubChannel(name: 'shared'),
    }),
    'info': PrintChannel(channel: 'info', isEnabled: true, subChannels: {
      'shared' : SubChannel(name: 'shared'),
    }),
  };
  
  Print(Object text, {String channel = '', String? subChannel}) {
    if (channel != '' && _channels[channel]!.isEnabled == false) {
      return;
    }

    _pen
      ..reset()
      ..cyan(bold: false);
    print(_pen(text));
  }

  Print.error(Object text, {String channel = '', String? subChannel}) {
    if (channel != '' && _channels[channel]!.isEnabled == false) {
      return;
    }

    _pen
      ..reset()
      ..red(bold: false);
    print(_pen(text));
  }

  Print.warning(Object text, {String channel = '', String? subChannel}) {
    if (channel != '' && _channels[channel]!.isEnabled == false) {
      return;
    }

    _pen
      ..reset()
      ..yellow(bold: false);
    print(_pen(text));
  }

  Print.success(Object text, {String channel = '', String? subChannel}) {
    if (channel != '' && _channels[channel]!.isEnabled == false) {
      return;
    }

    _pen
      ..reset()
      ..green(bold: false);
    print(_pen(text));
  }

  Print.debug(Object text, {String channel = '', String? subChannel}) {
    if (channel != '' && _channels[channel]!.isEnabled == false) {
      return;
    }

    _pen
      ..reset()
      ..xterm(129);
    print(_pen(text));
  }

  Print.fail(Object text, {String channel = '', String? subChannel}) {
    if (channel != '' && _channels[channel]!.isEnabled == false) {
      return;
    }

    _pen
      ..reset()
      ..red(bold: false);
    print(_pen(text));
  }

  static PrintChannel? getChannel(String channel, {String? subChannel}) {
    return _channels[channel];
  }

  static void addChannel(String channel, String name, {Map<String, SubChannel> subChannels = const {}}) {
    if (_channels[name] == null) {
      _channels[name] = new PrintChannel(channel: name, isEnabled: false, subChannels: subChannels);
    } else {
      throw (Exception('Channel already exists!'));
    }
  }

  static addSubChannel(String channel, SubChannel subChannel){
    if(_channels[channel] != null){
      if(_channels[subChannel]!.subChannels[subChannel.name] == null) {
        _channels[subChannel]!.subChannels[subChannel.name] = subChannel;
      }else{
        throw (Exception('Sub channel already exists!'));

      }
    }else{
      throw (Exception('Channel does not exist!'));
    }
  }
}

class PrintChannel {
  ///Whether or not the specific channel is enabled. This does not take into account the subchannels however.
  bool isEnabled = false;

  final String channel;
  final Map<String, SubChannel> subChannels;

  PrintChannel({this.isEnabled = false, required this.channel, this.subChannels = const {}});

  ///Toggles the channel on or off
  void toggle() {
    isEnabled = !isEnabled;
  }

  bool enabled({String? subChannel}) {
    if (subChannel == null) {
      return isEnabled;
    }
    if (subChannels[subChannel] == null) {
      return true;
    }

    return this.subChannels[subChannel]!.isEnabled;
  }
}

class SubChannel {
  final String name;
  bool isEnabled;

  SubChannel({required this.name, this.isEnabled = false});

  void toggle() {
    isEnabled = !isEnabled;
  }
}
