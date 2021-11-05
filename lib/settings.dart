import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Settingspage extends StatefulWidget {
  const Settingspage({Key? key}) : super(key: key);

  @override
  _SettingspageState createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Settings',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: -5,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: const Text('Privacy and Security'),
                  leading: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {
                    _launchURLBrowser();
                  },
                ),
                ListTile(
                  title: const Text('Share App'),
                  leading: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Rate App'),
                  leading: const Icon(
                    Icons.star,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Help and Support'),
                  leading: const Icon(
                    Icons.headset_mic,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('About'),
                  leading: const Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Lyrica',
                      applicationVersion: '1.0.1',
                      applicationLegalese:
                      'Copyright © Lyrica ${DateTime.now().year.toString()}',
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  void _launchURLBrowser() async {
    const url = 'https://github.com/sarangvs/privacy-policy/blob/main/privacy-policy.md';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void _launchURLBrowser_() async {
    const url = 'https://github.com/sarangvs/privacy-policy/blob/main/privacy-policy.md';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}
