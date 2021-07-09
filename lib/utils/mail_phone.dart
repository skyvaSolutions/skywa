import 'package:url_launcher/url_launcher.dart';

MailAndPhone mailAndPhone = new MailAndPhone();
class MailAndPhone{
  Future<void> contact(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}