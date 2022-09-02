import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Inward.dart';

var um_id;

class CJLogin extends StatefulWidget {
  const CJLogin({Key? key}) : super(key: key);

  @override
  State<CJLogin> createState() => _CJLoginState();
}

class _CJLoginState extends State<CJLogin> {

  var USERNAME = TextEditingController();
  var PASSWORD = TextEditingController();

  void Login() async {
    var url="http://yjapi.larch.in/Home/FetchLoginDetails?Login=${USERNAME.text}&Password=${PASSWORD.text}";
    var response=await http.get(Uri.parse(url));
    //print(response);
    var data=jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      if(data[i]['Message'] == ''){
        um_id= data[i]['um_iId'];
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Inward()));
      }
      else{
        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 15.0),));
        AlertDialog dialog = AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline_outlined),
              SizedBox(width: 7.0,),
              Text('Error',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
            ],
          ),
          content: Text('${data[i]['Message']}'),
          actions: [okbutton],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 130.0,),
              Container(
                child: Image.asset('CJ_Polytec.jpeg',
                  height: 120,
                  width: 120,
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('USER NAME : ',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      child: TextFormField(
                        controller: USERNAME,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('PASSWORD : ',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      child: TextFormField(
                        controller: PASSWORD,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blueAccent
                      ),
                      onPressed: () => Login(),
                      child: Text('Log In',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  Container(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.redAccent
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text('Exit',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () async => false);
  }
}
