import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStore extends StatefulWidget {
  const FireStore({super.key});

  @override
  State<FireStore> createState() => _FireStoreState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _FireStoreState extends State<FireStore> {
  @override
  Widget build(BuildContext context) {
    //Idler
    debugPrint("Firestore id: ${_firestore.collection("users").id}");
    debugPrint("Firestore id: ${_firestore.collection("users").doc().id}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('FireStore'),
            ElevatedButton(
                onPressed: () async {
                  veriEklemeAdd();
                },
                child: const Text('Veri Ekle Add')),
            ElevatedButton(
                onPressed: () {
                  veriEklemeSet();
                },
                child: const Text('Veri Ekle Set')),
            ElevatedButton(
                onPressed: () {
                  veriGuncelleme();
                },
                child: const Text("Veri Güncelle")),
            ElevatedButton(
                onPressed: () {
                  veriSil();
                },
                child: const Text("Veri Sil")),
            ElevatedButton(
                onPressed: () {
                  veriUpdateSil();
                },
                child: const Text("veriUpdateSil"))
          ],
        ),
      ),
    );
  }
}

veriEklemeAdd() async {
  Map<String, dynamic> eklenecekUser = <String, dynamic>{};
  eklenecekUser["isim"] = "taha";
  eklenecekUser["soyisim"] = "kaya";
  eklenecekUser["yas"] = 25;
  eklenecekUser["ogrenciMi"] = false;
  eklenecekUser["adres"] = {
    "il": "istanbul",
    "ilce": "kadikoy",
  };
  eklenecekUser["renkler"] = FieldValue.arrayUnion(["kirmizi", "mavi", "yesil"]);
  eklenecekUser["creadtedAt"] = FieldValue.serverTimestamp();

  await _firestore.collection("users").add(eklenecekUser);
}

veriEklemeSet() async {
  var yeniDocId = _firestore.collection("users").doc().id;
  await _firestore.doc("users/$yeniDocId").set({
    "isim": "mahmut",
    "soyisim": "kaya",
    "yas": 25,
    "ogrenciMi": false,
    "adres": {
      "il": "Elzig",
      "ilce": "kadikoy",
    },
    "renkler": FieldValue.arrayUnion(["sari", "mavi", "yesil"]),
    "creadtedAt": FieldValue.serverTimestamp(),
    "userId": yeniDocId,
  });

  await _firestore.doc("users/UgjRtOuZuYuzpKKx5pR0").set({"okul": "Ege Universitesi", "yas": FieldValue.increment(1)}, SetOptions(merge: true));
}

veriSil() {
  _firestore.doc("users/4cAG0MXFK5cyllnlfybQPC15kzP2").delete();
}

veriGuncelleme() async {
  await _firestore.doc("users/UgjRtOuZuYuzpKKx5pR0").update(
    {
      "isim": "güncel emre",
      "soyisim": "kaya",
      "ogrenciMi": true,
      "aaaaa": false,
      "adres.il": "izmir yeni ilce",
    },
  );
}

veriUpdateSil() async {
  await _firestore.doc("users/UgjRtOuZuYuzpKKx5pR0").update(
    {
      "aaaaa": FieldValue.delete(),
    },
  );
}
