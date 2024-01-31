import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uyishi_fluterfire/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class AddApp extends StatefulWidget {
  const AddApp({super.key});

  @override
  State<AddApp> createState() => _MyAppState();
}

class _MyAppState extends State<AddApp> {
  TextEditingController nametxt = TextEditingController();
  TextEditingController surnametxt = TextEditingController();
  final CollectionReference pupilsCollection =
      FirebaseFirestore.instance.collection("pupils");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nametxt,
            decoration: InputDecoration(
                label: Text("Name"), border: OutlineInputBorder()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: surnametxt,
            decoration: InputDecoration(
                label: Text("Surname"), border: OutlineInputBorder()),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            onPressed: () {
              setState(() {
                if (nametxt.text.length != 0 && surnametxt.text.length != 0) {
                  Map<String, dynamic> pupil = {
                    "name": nametxt.text,
                    "surname": surnametxt.text,
                  };
                  pupilsCollection.add(pupil);
                  nametxt = TextEditingController(text: "");
                  surnametxt = TextEditingController(text: "");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                      content: Text(
                    "Saqlandi",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent,
                      content: Text("Ism yoki familiya bo'sh", style: TextStyle(color: Colors.white, fontSize: 30),
                      )));
                }
              });
            },
            child: Text("Saqlash"),
            color: Colors.blue,
          ),
        ),
      ]),
    );
  }
}
