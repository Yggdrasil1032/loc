import 'package:flutter/material.dart';

class ToDoHomePage extends StatefulWidget {
  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _tasks.add({'title': task, 'isCompleted': false});
      });
      _taskController.clear();
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img_background_design.png'), // Arka plan görseli
              fit: BoxFit.cover, // Resmi ekrana göre boyutlandır
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 60),
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: 'Yeni Görev Ekle',
                    border: OutlineInputBorder(),
                    filled: true, // Arka plan rengini görünür yapar
                    fillColor: Colors.white.withOpacity(0.7), // Yarı şeffaf arka plan
                  ),
                  onSubmitted: _addTask,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _tasks.isEmpty
                      ? Center(
                    child: Text(
                      'Henüz bir görev eklenmedi!',
                      style: TextStyle(fontSize: 18,color: Colors.black45),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            task['title'],
                            style: TextStyle(
                              decoration: task['isCompleted']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          leading: Checkbox(
                            value: task['isCompleted'],
                            onChanged: (_) => _toggleTaskCompletion(index),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTask(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _addTask(_taskController.text),
            child: Icon(Icons.add),
        ),
        );
    }
}
