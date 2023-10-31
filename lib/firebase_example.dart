import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudFirestoreExample extends StatefulWidget {
  const CloudFirestoreExample({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<CloudFirestoreExample> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final CollectionReference users =
  FirebaseFirestore.instance.collection("users");
  final AuthService authService = AuthService();
  String userId = "";
  signUp() async {
    final User? user = await authService.signUp(
      _emailController.text,
      _passwordController.text,
    );
    await users.add({
      "name": _nameController.text,
      "email": _emailController.text,
    });
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Sign up successful!",
        ),
      ));
    }
  }

  editUser(String id) async {
    await users.doc(id).update(
      {
        "name": _nameController.text,
        "email": _emailController.text,
      },
    );
  }

  deluser(String id) async {
    await users.doc(id).delete();
  }

  signIn() async {
    final User? user = await authService.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Sign In successful!",
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: signUp,
              child: const Text("Sign Up"),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: signIn,
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () {
                editUser(userId);
                userId = "";
              },
              child: const Text("Update"),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final userList = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(userList[index]["name"]),
                          subtitle: Text(userList[index]["email"]),
                          trailing:
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _nameController.text =
                                  userList[index]["name"];
                                  _emailController.text =
                                  userList[index]["email"];
                                  userId = userList[index].id;
                                });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deluser(userList[index].id);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ]),
                        );
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class AuthService {
  final firebase_auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
      await firebase_auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
      await firebase_auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
    }
  }

  signOut() async {
    try {
      firebase_auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
