import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String userTodo = '';
  List todoList = [];

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
    todoList.addAll(['Buy milk', 'Wash dishes']);
  }

  void menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext ctx) {
        return Scaffold(
         appBar: AppBar(title: Text('Menu'),),
          body: Row(
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }, child: Text('On main'))
            ],
          ),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('TODO list'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: menuOpen,
              icon: Icon(
                  Icons.menu
              )
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text ('No data');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Dismissible(
                key: Key(snapshot.data!.docs[index].id),
                child: Card(
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index].get('item')),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          todoList.removeAt(index);
                        });
                      },
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  // if (direction == DismissDirection.endToStart)\
                  setState(() {
                    todoList.removeAt(index);
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text("Add new element"),
              content: TextField(
                onChanged: (String value) {
                  userTodo = value;
                },
              ),
              actions: [
                ElevatedButton(onPressed: () {
                  FirebaseFirestore.instance.collection('items').add({'item': userTodo});
                  // setState(() {
                  //   todoList.add(userTodo);
                  // });
                  Navigator.of(ctx).pop();
                }, child: Text('Add!'))
              ],
            );
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}
