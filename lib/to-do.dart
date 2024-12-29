import 'package:flutter/material.dart';
import 'package:life_on_campus/main_page.dart';

import 'clubs_page.dart';
import 'daily_menu.dart';

class ToDoHomePage extends StatefulWidget {
  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Sayfa geçişleri
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClubsPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MealMenuScreen()),
      );
    }
  }

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
             image: AssetImage('assets/img_background_design.png'),
            fit: BoxFit.cover
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Yeni Görev Ekle',
                  labelStyle: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: 'Görev girin...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  prefixIcon: Icon(
                    Icons.task_alt,
                    color: Colors.teal,
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Colors.red[900]),
                onSubmitted: _addTask,
              ),
              SizedBox(height: 16),
              Expanded(
                child: _tasks.isEmpty
                    ? Center(
                  child: Text(
                    'Henüz bir görev eklenmedi!',
                    style: TextStyle(fontSize: 18, color: Colors.tealAccent),
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
                          onChanged: (_) =>
                              _toggleTaskCompletion(index),
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

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Daily Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black87,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
        ),
        onTap: _onItemTapped,
        elevation: 8,
        type: BottomNavigationBarType.fixed, // Düz tasarım
      ),
    );
  }
}


