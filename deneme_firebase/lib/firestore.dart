import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStore extends StatefulWidget {
  const FireStore({super.key});

  @override
  State<FireStore> createState() => _FireStoreState();
}

StreamSubscription? _userSubsribe;
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
                child: const Text("veriUpdateSil")),
            ElevatedButton(
                onPressed: () {
                  //veriOkumaTime();
                  veriOkumaRealTimeOneUsers();
                },
                child: const Text("Veri Okuma Time")),
            ElevatedButton(
                onPressed: () {
                  batchKavrami();
                },
                child: const Text("Batch Kavrami")),
            ElevatedButton(onPressed: () {}, child: const Text("Transaction Kavrami"))
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

//bir kerelik çalışıyor
veriOkumaTime() async {
  var usersDocuments = await _firestore.collection("users").get();
  debugPrint(usersDocuments.size.toString());
  debugPrint(usersDocuments.docs.length.toString()); //bu şekilde de döküman sayısını alabiliriz
  for (var eleman in usersDocuments.docs) {
    debugPrint("Dokuman id: ${eleman.id}");
    Map userMap = eleman.data();
    debugPrint(userMap["isim"]);

    var emreDoc = await _firestore.doc("users/y98oFDi7OZ6l12CFPVUR").get();
    debugPrint("emreDoc: ${emreDoc.data().toString()}");
  }
}

// sürekli çalışıyor
veriOkumaRealTime() async {
  var userStream = _firestore.collection("users").snapshots();
  _userSubsribe = userStream.listen((event) {
    userStream.forEach((element) {
      // for (var element in element.docChanges) {
      //   debugPrint(element.doc.data().toString());
      // }
      for (var element in element.docs) {
        debugPrint(element.data().toString());
      }
    });
  });
}

// sürekli çalışıyor sadece bir kullanıcıyı dinler
veriOkumaRealTimeOneUsers() async {
  // var userStream = _firestore.collection("users").snapshots();
  var userDocStream = _firestore.doc("users/UgjRtOuZuYuzpKKx5pR0").snapshots();

  _userSubsribe = userDocStream.listen((event) {
    userDocStream.forEach((element) {
      // for (var element in element.docChanges) {
      //   debugPrint(element.doc.data().toString());
      // }
      //bu şekilde tüm kullanıcıları dinleyebiliriz

      debugPrint(event.data().toString());
    });
  });
}

// dinlemeyi durdurmak için
streamDurdur() async {
  await _userSubsribe?.cancel();
}

//batch kavramı birden fazla işlemi aynı anda yapmamızı sağlar
batchKavrami() async {
  WriteBatch batch = _firestore.batch();
  CollectionReference counterColRef = _firestore.collection('counter');

  //batc ile aynı anda 100 tane dokuman ekleyebiliriz
  // for (int i = 0; i < 100; i++) {
  //   var yeniDocId = counterColRef.doc();
  //   batch.set(yeniDocId, {'sayac': ++i, 'docId': yeniDocId.id});
  // }

//batch ile aynı anda timestamp ekleyebiliriz
  // var counterDocs = await counterColRef.get();
  // for (var element in counterDocs.docs) {
  //   batch.update(element.reference, {'createdAt': FieldValue.serverTimestamp()});
  // }

  //batch ile aynı anda silme işlemi yapabiliriz
  var counterDocs = await counterColRef.get();
  for (var element in counterDocs.docs) {
    batch.delete(element.reference);
  }

  await batch.commit();
}

