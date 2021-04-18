import 'package:flutter/material.dart';
class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  
       
         Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),backgroundColor: Theme.of(context).primaryColor ,));
      
    
  }
}