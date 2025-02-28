import 'package:flutter/material.dart';
import '../db_helper.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _users = [];

  // Fetch all users from the database
  Future<void> fetchUsers() async {
    final db = await DBHelper().database;  // ✅ Correct usage
    final data = await db.query('users');
    setState(() {
      _users = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();  // Fetch users when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: _users.isEmpty
          ? const Center(child: Text('No users found.'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['fullname']),
            subtitle: Text('Type: ${user['type']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final db = await DBHelper().database;  // ✅ Correct usage
                await db.delete(
                  'users',
                  where: 'id = ?',
                  whereArgs: [user['id']],
                );
                fetchUsers();  // Refresh the list after deletion
              },
            ),
          );
        },
      ),
    );
  }
}
