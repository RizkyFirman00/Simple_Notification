import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final TextEditingController secondsController = TextEditingController();
  int numberExt = 0;
  bool isCounting = false;

  void countingNumber() async {
    if (secondsController.text.isNotEmpty) {
      int target = int.tryParse(secondsController.text) ?? 0;

      setState(() {
        numberExt = 0;
        isCounting =
            true;
      });

      for (int i = 0; i <= target; i++) {
        await Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            numberExt = i;
          });
        });
      }

      setState(() {
        isCounting = false;
      });

      if (numberExt == target) {
        _showNotification("$numberExt Detik", "Notifikasi Timer");
      }
    }
  }

  Future<void> _initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String titleNotif, String descNotif) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotif,
      descNotif,
      platformChannelSpecifics,
    );
  }

  @override
  void dispose() {
    secondsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Belajar Push Notif",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: secondsController,
                    decoration: InputDecoration(
                      enabled: isCounting ? false : true,
                      labelText: "Number",
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: isCounting ? null : countingNumber,
                  icon: Icon(Icons.save, size: 40, color: isCounting ? Colors.grey : Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(height: 10),
            isCounting
                ? Text("Menghitung: $numberExt")
                : Text("Hasil: $numberExt"),
          ],
        ),
      ),
    );
  }
}
