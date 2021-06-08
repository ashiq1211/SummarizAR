import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:project/plan.dart';
import 'package:scoped_model/scoped_model.dart';
class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  var _selected=plan.planFree;
  @override
  Widget build(BuildContext context) {
     return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
    return Scaffold(

      body:
      Container(height: MediaQuery.of(context).size.height,child:
      Column(children: [
        SizedBox(height: 100,),
        
        Align(alignment: Alignment.center, child:Text(" Choose \nyour plan", style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                          fontSize: 27.0,
                        
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),),
                        
                        ), SizedBox(height: 20,),
                        Padding(padding: EdgeInsets.symmetric (horizontal: 20),child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ListTile(leading:Icon(Feather.check,color: Colors.green[700],) ,title: Text("Get unlimited summary")),
                          ListTile(leading:Icon(Feather.check,color: Colors.green[700],) ,title: Text("No Ads"))
                        ],), ),
                        
                       
                        SizedBox(height: 50,),
                        GridView.count(
                          crossAxisSpacing: 28,
                          mainAxisSpacing: 18,
                          crossAxisCount: 2,  scrollDirection: Axis.vertical,
    shrinkWrap: true,childAspectRatio: 2,padding: EdgeInsets.all(20), children: [
      Card(color: _selected==plan.planFree?Colors.green[200]:Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),side: BorderSide(color: Colors.grey, width: 0.5)
      ),child:ListTile(
        onTap: (){
          setState(() {
            _selected=plan.planFree;
          });
        },
        trailing:  _selected==plan.planFree?Icon(Feather.check_circle):null,
        title: Text("Free",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),subtitle: Text("7 days"),),),
      Card(color: _selected==plan.plan80?Colors.green[200]:Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),side: BorderSide(color: Colors.grey, width: 0.5)
      ),child:ListTile( onTap: (){
          setState(() {
            _selected=plan.plan80;
          });
        },
        trailing:  _selected==plan.plan80?Icon(Feather.check_circle):null,title: Text("INR 80",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),subtitle: Text("30 days"),shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),),),
      Card(color: _selected==plan.plan200?Colors.green[200]:Colors.white,shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),side: BorderSide(color: Colors.grey, width: 0.5)
      ),child:ListTile( onTap: (){
          setState(() {
            _selected=plan.plan200;
          });
        },
        trailing:  _selected==plan.plan200?Icon(Feather.check_circle):null,title: Text("INR 200",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),subtitle: Text("60 days"),shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),),),
      Card(color: _selected==plan.plan350?Colors.green[200]:Colors.white,shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),side: BorderSide(color: Colors.grey, width: 0.5)
      ),child:ListTile( onTap: (){
          setState(() {
            _selected=plan.plan350;
          });
        },
        trailing:  _selected==plan.plan350?Icon(Feather.check_circle):null,title: Text("INR 350",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),subtitle: Text("90 days"),shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),)

                        ),
                        
                         
                       
                        ],
                      
                        ),
                        TextButton(onPressed: (){}, child: Text("See Terms and Conditions",style: TextStyle(
                         
                          color: Colors.grey,
                        ))),
                       
                        ElevatedButton(
                          
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 48),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: Colors.grey[900], // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async{
                    //  model.uploadPack("sdjd"); 
                     if(_selected==plan.planFree){
 Navigator.of(context).pop();
                 Navigator.pushNamed(context, "/cameraPage");
                     } else{
                       Navigator.of(context).pop();
                 Navigator.pushNamed(context, "/signup");
                     }  
                

                        },
                        child: Text('Continue'))
                        ],) 
    ))
;  });}

}
