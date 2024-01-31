import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uyishi_fluterfire/firebase_options.dart';
import 'package:uyishi_fluterfire/save.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController nameEdit = TextEditingController();
  TextEditingController surnameEdit = TextEditingController();
  CollectionReference pupilsCollection =
      FirebaseFirestore.instance.collection("pupils");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("O'quvchilar"),
        actions: [],
      ),
      body: StreamBuilder(
          stream: pupilsCollection.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onLongPress: (){
                              pupilsCollection.doc(document.id).delete();
                            },
                            onTap: (){
                              nameEdit = TextEditingController(text: document['name']);
                              surnameEdit = TextEditingController(text: document['surname']);
                              showDialog(context: context, builder: (_){
                                return AlertDialog(
                                  title: Text("Malumotni o'zgartirish"),
                                  actions: [
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: nameEdit,
                                          decoration: InputDecoration(
                                              label: Text("Name",), border: OutlineInputBorder()),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: surnameEdit,
                                          decoration: InputDecoration(
                                              label: Text("Name"), border: OutlineInputBorder()),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Bekor qilish")),
                                        MaterialButton(
                                          onPressed: (){
                                            pupilsCollection.doc(document.id).update({
                                              "name":nameEdit.text,
                                              "surname":surnameEdit.text
                                            });
                                            Navigator.pop(context);
                                            surnameEdit.clear();
                                            nameEdit.clear();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.lightBlueAccent, content: Text("O'zgartirildi", style: TextStyle(color: Colors.white, fontSize: 30),)));
                                          },
                                          child: Text("Saqlash"),
                                        )
                                      ],)
                                    ],)
                                  ],
                                );
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent[200],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 3, color: Colors.black12)
                              ),
                              child: ListTile(
                                title: Text(document['name'],
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
                                subtitle: Text(document['surname'],
                                    style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold, fontSize: 20)),
                              ),
                            ),
                          ),
                        );
                      }));
            }  else if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text("Malumot yo'q"));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddApp()))
              .then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
