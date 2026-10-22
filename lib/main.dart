import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

final messageStream = BehaviorSubject<RemoteMessage>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // Register StudyBuddy with Firebase Cloud Messaging.
  const vapidKey =
      'BNR1fC3NA2oeNYIyVhRGdK19M_gEKQN9Cxhw_NNvlDYD7_UqGTraZG_IJEIB8C9tsg0GeAJcaVDYsabYVQNgd5Y';

  String? token;

  if (kIsWeb) {
    token = await messaging.getToken(vapidKey: vapidKey);
  } else {
    token = await messaging.getToken();
  }

  if (kDebugMode) {
    print('FCM registration token : $token');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('StudyBuddy received a message!');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    }

    messageStream.add(message);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const StudyBuddyHome(),
    );
  }
}

class StudyBuddyHome extends StatefulWidget {
  const StudyBuddyHome({super.key});

  @override
  State<StudyBuddyHome> createState() => _StudyBuddyHomeState();
}

class _StudyBuddyHomeState extends State<StudyBuddyHome> {
  RemoteMessage? latestMessage;
  final List<String> tasks = [
    'Complete Flutter assignment',
    'Revise Java OOP',
    'Study Firebase Cloud Messaging',
  ];

  @override
  void initState() {
    super.initState();

    messageStream.listen((message) {
      if (mounted) {
        setState(() {
          latestMessage = message;
        });
      }
    });
  }

  void addTask() {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Study Task'),
          content: TextField(
            controller: taskController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter your study task',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newTask = taskController.text.trim();

                if (newTask.isNotEmpty) {
                  setState(() {
                    tasks.add(newTask);
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Save Task'),
            ),
          ],
        );
      },
    ).whenComplete(taskController.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyBuddy'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to StudyBuddy!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Organize your assignments and study tasks.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            if (latestMessage != null)
              Card(
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'StudyBuddy Notification',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        latestMessage!.notification?.title ?? 'New Message',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        latestMessage!.notification?.body ??
                            'You have a new notification.',
                      ),
                    ],
                  ),
                ),
              ),

            if (latestMessage != null) const SizedBox(height: 20),

            const Text(
              'My Study Tasks',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(tasks[index]),
                      trailing: const Icon(Icons.check_circle_outline),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addTask,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
