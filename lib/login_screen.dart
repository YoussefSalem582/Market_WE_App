// import 'package:flutter/material.dart';
// import 'admin/admin_dashboard.dart';
// import 'db_helper.dart';
// import 'registration_screen.dart';
// import 'user/user_dashboard.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _fullnameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       final fullname = _fullnameController.text.trim();
//       final password = _passwordController.text.trim();
//
//       // Login logic: Call DBHelper to fetch user data
//       final user = await DBHelper().loginUser(fullname, password);
//
//       if (user != null) {
//         final userType = user['type'];
//         final userId = user['id']; // Get userId from the user object
//
//         if (userType == 'admin') {
//           // Navigate to admin dashboard
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => AdminDashboard()),
//           );
//         } else {
//           // Navigate to user dashboard and pass userId
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => UserDashboard(userId: userId),
//             ),
//           );
//         }
//       } else {
//         // Show error message if login fails
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid credentials')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Market WE',
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'font1',
//             fontSize: 32,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepPurple, Colors.purpleAccent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: SingleChildScrollView(
//               child: Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Login to Your Account',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         TextFormField(
//                           controller: _fullnameController,
//                           decoration: InputDecoration(
//                             labelText: 'Full Name',
//                             prefixIcon: const Icon(Icons.person),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your full name';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         TextFormField(
//                           controller: _passwordController,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             prefixIcon: const Icon(Icons.lock),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           obscureText: true,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: _login,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepPurple,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 16, horizontal: 22),
//                             textStyle: const TextStyle(fontSize: 22),
//                           ),
//                           child: const Text(
//                             'Login',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => RegisterScreen()),
//                             );
//                           },
//                           child: const Text(
//                             'No account? Create one',
//                             style: TextStyle(color: Colors.deepPurple),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'admin/admin_dashboard.dart';
import 'db_helper.dart';
import 'registration_screen.dart';
import 'test/session_manager.dart';
import 'user/user_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // New: Track loading state

  // Login logic: Validate credentials and navigate to the appropriate dashboard
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Show loading spinner
      final fullname = _fullnameController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final user = await DBHelper().loginUser(fullname, password);
        if (user != null) {
          final userType = user['type'];
          final userId = user['id'];

          // Save user session with SharedPreferences
          await SessionManager().saveUserSession(userId, userType);

          // Navigate to the respective dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
              userType == 'admin' ? AdminDashboard() : UserDashboard(userId: userId),
            ),
          );
        } else {
          // Show error message if login fails
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid credentials')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false); // Stop loading spinner
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market WE',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'font1',
            fontSize: 32,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Login to Your Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _fullnameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator() // Show loading spinner during login
                            : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 22),
                            textStyle: const TextStyle(fontSize: 22),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: const Text(
                            'No account? Create one',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
