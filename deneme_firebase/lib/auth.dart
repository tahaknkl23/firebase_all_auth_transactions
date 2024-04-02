import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // late FirebaseAuth auth;
  // final email = 'taha@gmail.com';
  // final password = '123456';

  // @override
  // void initState() {
  //   super.initState();
  //   auth = FirebaseAuth.instance;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Auth'),
            TextField(
              controller: _emailController,
            ),
            TextField(
              controller: _passwordController,
            ),
            ElevatedButton(
                onPressed: () async {
                  debugPrint(_emailController.text);
                  debugPrint(_passwordController.text);
                  await createUserEmailAndPassword(_emailController.text, _passwordController.text);

                  // await createUserEmailAndPassword("taha@gmail.com", "123456");
                },
                child: const Text('Auth')),
            ElevatedButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: const Text('Google Auth')),
            ElevatedButton(
                onPressed: () {
                  CikisYap();
                },
                child: const Text('gogle çikis')),
          ],
        ),
      ),
    );
  }
}

Future<void> createUserEmailAndPassword(String email, String password) async {
  var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  debugPrint(userCredential.toString());
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
// Kimlik doğrulama akışını tetikleyin
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  // İsteğin kimlik doğrulama ayrıntılarını alın
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  // Yeni bir kimlik oluşturun
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  // Oturum açıldıktan sonra UserCredential'ı döndürün
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

void CikisYap() async {
  var user = GoogleSignIn().currentUser;
  if (user != null) {
    await GoogleSignIn().signOut();
  }
  await GoogleSignIn().disconnect();
  debugPrint("Çıkış yapıldı");
}
