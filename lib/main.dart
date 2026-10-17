
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
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
  final List<String> tasks = [
    'Complete Flutter assignment',
    'Revise Java OOP',
    'Study Firebase Cloud Messaging',
  ];

  
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
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to StudyBuddy!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Organize your assignments and study tasks.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'My Study Tasks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
