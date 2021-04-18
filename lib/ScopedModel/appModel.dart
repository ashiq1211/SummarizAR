import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Model/user.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  bool loading = false;
  bool haserror = false;
  String message = 'Something wrong';
 
  
}

class UserModel extends AppModel {
   bool get load{
     return loading;
  }
     Future <Map<dynamic,dynamic>> signup(String email, String password) async{
       haserror = false;
       loading=true;
       notifyListeners();
       try {
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password
  );
 
  
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
   message='The password provided is too weak.';
   haserror=true;
   notifyListeners();
  } else if (e.code == 'email-already-in-use') {
    message='The account already exists for that email.';
    haserror=true;
    notifyListeners();
  }else{
     var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
        
          message = "Check your Internet Connectivity";
          haserror=true;
          notifyListeners();
          
          

        }
  }
} catch (e) {
  
}
loading=false;
notifyListeners();
print(message);
return {"message":message,"error":haserror};
     }

     Future <Map<dynamic,dynamic>> signin(String email, String password) async{
       haserror = false;
       loading=true;
       notifyListeners();
       try {
  final UserCredential user = await FirebaseAuth.instance
             .signInWithEmailAndPassword(email: email, password: password);

  print(FirebaseAuth.instance.currentUser.uid);
  
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    message=('No user found for that email.');
     haserror=true;
   notifyListeners();
  } else if (e.code == 'wrong-password') {
    message=('Wrong password provided for that user.');
  
    haserror=true;
    notifyListeners();
  }else{
     var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
        
          message = "Check your Internet Connectivity";
          haserror=true;
          notifyListeners();
          
          

        }
  }
} catch (e) {
  
}
loading=false;
notifyListeners();
print(message);
return {"message":message,"error":haserror};
     }

     Future signout()async{
       await FirebaseAuth.instance.signOut();
       print("object");
     }
  
}
