import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
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
  String recognizedText=" ";
  List<Doc> itemList=[];
   List<Doc> get doclist{
    return List.from(itemList);
  }
  int flag = 0;
  double cur = 0.0;
   String get recognizedTxt{
    return recognizedText;}
  
 

  Future<Map<dynamic, dynamic>> recognizeText(File imagePath) async {
    
  
  //  String formattedDate = DateFormat('dd-MM-yy kk:mm').format(date);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId=prefs.getString("userId");
  //   final mainReference =
  //       FirebaseDatabase.instance.reference().child('$userId/Documents');
    haserror = false;
    loading = true;
    notifyListeners();
    try {

  final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imagePath);
        final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
        final VisionText visionText =
        await textRecognizer.processImage(visionImage);
        if (visionText.blocks.isNotEmpty) {
           recognizedText = " ";
           print("xzbjkxcbcxjk");
           
    } else if (visionText.blocks.isEmpty) {
      recognizedText = "Something went wrong...";
      print("uoo");
      haserror=true;
      notifyListeners();
      return null;
    
    }
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        

          if (flag == 1) {
            if (line.boundingBox.top > cur + 50.0) {
 
              recognizedText += "\n";
            }
          }
          cur = line.boundingBox.bottom;
          recognizedText += line.text;
          recognizedText += " ";
          flag = 1;
       
      }
    }
  



    } on FirebaseException catch (e) {
      
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          message = "Check your Internet Connectivity";
          haserror = true;
    
        }
      
    } catch (e) {}
    // loading = false;
    // notifyListeners();
    print(message);
    return {"message": message, "error": haserror,"TextRecognized":recognizedText};
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

 Future<void> refreshDoc() async {
    getDoc();
  }

  Future<Map<dynamic, dynamic>> getDoc() async {
     itemList=[]; 
    haserror = false;
    loading = true;
    notifyListeners();
  
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("userId");
    final mainReference =
        FirebaseDatabase.instance.reference().child('$userId/Documents');

    try {
      
     
       
mainReference.once().then((DataSnapshot snap) {

  if(snap.value==null){
    loading=false;
    notifyListeners();
    return null;
  }
      print("Swaty");
    
      var data = snap.value;
      print(data);
     
      
      data.forEach((key, value) {
        Doc m = new Doc(link:value['PDF'], name:value['FileName'],date: value['Date'], path:value["ActualDate"]);
        itemList.add(m);
        // notifyListeners();
      });
     itemList.sort((a,b) => a.name.compareTo(b.name));
     itemList=itemList.reversed.toList();
      notifyListeners();
      print(itemList);
         print("kooy");
    loading = false;
    
    notifyListeners();
    print(message);
   
      
    });

    } on FirebaseException catch (e) {
      
   
     
    } catch (e) {

      loading=false;
      notifyListeners();
    }     var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          message = "Check your Internet Connectivity";
          haserror = true;
          loading=false;
          notifyListeners();
        }
    print(haserror);
     return {"message": message, "error": haserror};
 
  }

  
}
