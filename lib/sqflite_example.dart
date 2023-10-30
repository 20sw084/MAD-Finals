import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class SqfLiteExample extends StatefulWidget {
  const SqfLiteExample({super.key});

  @override
  State<SqfLiteExample> createState() => _SqfLiteState();
}

class _SqfLiteState extends State<SqfLiteExample> {
  List<Note> notes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int selectedId = -1;

  Future<void> _loadnotes() async {
    DbHelper dbHelper = DbHelper();
    final notelist = await dbHelper.queryAll();
    setState(() {
      notes = notelist;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadnotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sqflite"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            DbHelper dbHelper = DbHelper();
                            await dbHelper.delete(note.id!);
                            _loadnotes();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              titleController.text = note.title;
                              contentController.text = note.content;
                              selectedId = note.id!;
                            });
                          },
                        ),
                      ]),
                    );
                  },
                )),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: "Content",
              ),
            ),
            Row(children: [
              ElevatedButton(
                onPressed: () async {
                  DbHelper dbHelper = DbHelper();
                  Note note = Note(
                    title: titleController.text,
                    content: contentController.text,
                  );
                  await dbHelper.insert(note);
                  _loadnotes();
                  titleController.clear();
                  contentController.clear();
                },
                child: const Text("Insert Task"),
              ),
              ElevatedButton(
                onPressed: () async {
                  DbHelper dbHelper = DbHelper();
                  Note note = Note(
                    id: selectedId,
                    title: titleController.text,
                    content: contentController.text,
                  );
                  await dbHelper.update(note);
                  _loadnotes();
                  titleController.clear();
                  contentController.clear();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Operation Successful'),
                        content: Text(
                          "Update Done",
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Update Task"),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class DbHelper {
  static Database? _database;
  final String tablename = "notes";

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDb();
      return _database!;
    }
  }

  Future<Database> initDb() async {
    final dbpath = await getDatabasesPath();
    final note_db_path = join(dbpath, "notes.db");

    return await openDatabase(
      note_db_path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $tablename(id INTEGER PRIMARY KEY, title TEXT, content TEXT)",
        );
      },
    );
  }

  insert(Note note) async {
    final db = await database;
    await db.insert(
      tablename,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  update(Note note) async {
    final db = await database;
    await db.update(
      tablename,
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  delete(int id) async {
    final db = await database;
    await db.delete(tablename, where: "id = ?", whereArgs: [id]);
  }

  Future<List<Note>> queryAll() async {
    final db = await database;
    List<Map<String, dynamic>> notes = await db.query(tablename);
    return List.generate(notes.length, (index) {
      return Note(
        id: notes[index]["id"],
        title: notes[index]["title"],
        content: notes[index]["content"],
      );
    });
  }
}

class Note {
  final int? id;
  final String title;
  final String content;

  Note({this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "content": content};
  }
}