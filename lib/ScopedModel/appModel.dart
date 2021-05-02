import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:project/Model/doc.dart';
import 'package:project/Model/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends Model {
  bool loading = false;
  bool haserror = false;
  String message = 'Something wrong';
  String userId=" ";

}

class UserModel extends AppModel {
  bool get load {
    return loading;
  }

  Future<Map<dynamic, dynamic>> signup(String email, String password) async {
    haserror = false;
    loading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('userId', FirebaseAuth.instance.currentUser.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
        haserror = true;
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
        haserror = true;
        notifyListeners();
      } else {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          message = "Check your Internet Connectivity";
          haserror = true;
          notifyListeners();
        }
      }
    } catch (e) {}
    loading = false;
    notifyListeners();
    print(message);
    return {"message": message, "error": haserror};
  }

  Future<Map<dynamic, dynamic>> signin(String email, String password) async {
    haserror = false;
    loading = true;
    notifyListeners();
    try {
      final UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

    SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('userId', FirebaseAuth.instance.currentUser.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = ('No user found for that email.');
        haserror = true;
        notifyListeners();
      } else if (e.code == 'wrong-password') {
        message = ('Wrong password provided for that user.');

        haserror = true;
        notifyListeners();
      } else {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          message = "Check your Internet Connectivity";
          haserror = true;
          notifyListeners();
        }
      }
    } catch (e) {}
    loading = false;
    notifyListeners();
    print(message);
    return {"message": message, "error": haserror};
  }

  Future signout() async {
    await FirebaseAuth.instance.signOut();
    print("object");
  }
}

class DocumentModel extends AppModel{
  List<Doc> itemList=[];
  List<Doc> get doclist{
    return List.from(itemList);
  }
  
   
  Future<Map<dynamic, dynamic>> putDoc(List<int> asset,DateTime date) async {
    
  
   String formattedDate = DateFormat('dd-MM-yy kk:mm').format(date);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("userId");
    final mainReference =
        FirebaseDatabase.instance.reference().child('$userId/Documents');
    haserror = false;
    loading = true;
    notifyListeners();
    try {
       String createCryptoRandomString([int length = 32]) {
      final Random _random = Random.secure();
      var values = List<int>.generate(length, (i) => _random.nextInt(256));
      return base64Url.encode(values);
    }

    void documentFileUpload(String str, String name) {
      var data = {
        "PDF": str,
        "FileName": name,
        "Date" :formattedDate,
        "ActualDate":date.toString()
        
      };
      mainReference.child(createCryptoRandomString()).set(data).then((value) {
        print("Successfully");
        print(str);
      });
    }
    
    
      Reference reference = FirebaseStorage.instance.ref().child("$userId/Documents/$date");
      UploadTask uploadTask = reference.putData(asset);

      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      final url = imageUrl.toString();
      print(url);
      documentFileUpload(url, date.toString());
   


    } on FirebaseException catch (e) {
      
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          message = "Check your Internet Connectivity";
          haserror = true;
          notifyListeners();
        }
      
    } catch (e) {}
    loading = false;
    notifyListeners();
    print(message);
    return {"message": message, "error": haserror};
  }



  Future<Map<dynamic, dynamic>> getDoc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("userId");
    final mainReference =
        FirebaseDatabase.instance.reference().child('$userId/Documents');
    haserror = false;
    loading = true;
    notifyListeners();
    try {
      
mainReference.once().then((DataSnapshot snap) {
  if(snap.value==null){
    return;
  }
      print("Swaty");
      print(snap);
      var data = snap.value;
      print(data);
     
      itemList.clear();
      data.forEach((key, value) {
        Doc m = new Doc(link:value['PDF'], name:value['FileName'],date: value['Date'], path:value["ActualDate"]);
        itemList.add(m);
        notifyListeners();
      });
      print(itemList);
      
    });

    } on FirebaseException catch (e) {
      
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          message = "Check your Internet Connectivity";
          haserror = true;
          notifyListeners();
        }
     
    } catch (e) {}
    loading = false;
    notifyListeners();
    print(message);
    return {"message": message, "error": haserror};
  }

  
}
