import 'dart:convert';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CJLogin.dart';
import 'Inward.dart';
import 'LOCMAP.dart';
import 'Out(FG).dart';
import 'Out(RM/BOP).dart';

class LOCICHANGE extends StatefulWidget {
  const LOCICHANGE({Key? key}) : super(key: key);

  @override
  State<LOCICHANGE> createState() => _LOCICHANGEState();
}

class _LOCICHANGEState extends State<LOCICHANGE> {

  BsSelectBoxController Source = BsSelectBoxController();

  void SourceRack () async {
    var url="http://yjapi.larch.in/Home/FetchRack";
    var response=await http.get(Uri.parse(url));
    var data= jsonDecode(response.body);
    Source.setOptions([
      for(int i=0;i<data.length;i++)
        BsSelectBoxOption(value: data[i]['Id'], text: Text('${data[i]['Value']}'))
    ]);
  }


  BsSelectBoxController Destination = BsSelectBoxController();

  void DestRack () async {
    var url="http://yjapi.larch.in/Home/FetchRack";
    var response=await http.get(Uri.parse(url));
    var data= jsonDecode(response.body);
    Destination.setOptions([
      for(int i=0;i<data.length;i++)
        BsSelectBoxOption(value: data[i]['Id'], text: Text('${data[i]['Value']}'))
    ]);
  }

  void LocChange () async {
    var url_2 = "https://yjapi.larch.in/Home/LocationExchange?RackFrom=${Source.getSelected()!.getValue()}&RackTo=${Destination.getSelected()!.getValue()}&CreatedBy=$um_id";
    var response = await http.get(Uri.parse(url_2));
    var data_2 = jsonDecode(response.body);
    for(int i=0;i<data_2.length;i++)
    {
      if(data_2[i]['Success'] != '')
      {
        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 15.0),));
        AlertDialog dialog = AlertDialog(
          title: Row(
            children: [
              Icon(Icons.cloud_done),
              SizedBox(width: 7.0,),
              Text('LOCATION CHANGE',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
            ],
          ),
          content: Text('${data_2[i]['Success']}'),
          actions: [okbutton],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
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
              Text('LOCATION CHANGE',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
            ],
          ),
          content: Text('${data_2[i]['Errors']}'),
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
  void initState() {
    // TODO: implement initState
    SourceRack ();
    DestRack ();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CJ'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(15.0),
          children: [
            // SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Align(alignment: Alignment.center,child: Image(image: AssetImage('CJ_Polytec.jpeg'),), )
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: 15.0,),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.input_sharp),
                  SizedBox(width: 10.0,),
                  Text('INWARD'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Inward()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.output_sharp),
                  SizedBox(width: 10.0,),
                  Text('OUTWARD (RM/BOP)'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>out_1()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.output_sharp),
                  SizedBox(width: 10.0,),
                  Text('SALES'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OUT_2()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.location_on_rounded),
                  SizedBox(width: 10.0,),
                  Text('LOCATION MAPPING'),
                ],
              ),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>LOCMAP()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.location_on_rounded),
                  SizedBox(width: 10.0,),
                  Text('LOCATION INTERCHANGE'),
                ],
              ),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>LOCICHANGE()));
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.logout_rounded),
                  SizedBox(width: 10.0,),
                  Text('LOGOUT'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CJLogin()));
              },
            ),
            SizedBox(height: 120.0,),
            Divider(
              height: 1,
              thickness: 1,
            ),
            // SizedBox(height: 120.0,),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Center(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Image(image: AssetImage('LarchTREE.png')),
                            // Icon(Icons.terrain_rounded),
                            SizedBox(width: 2.0,),
                            Text('  ERP - v 1.0.1',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: Row(
                  children: [
                    Icon(Icons.keyboard_double_arrow_right),
                    Text('LOCATION INTERCHANGE ',style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          child: Text('SOURCE LOCATION : '),
                          alignment: Alignment.topLeft,
                        ),
                        SizedBox(height: 20.0,),
                        Expanded(child: BsSelectBox(
                          hintText: 'select SourceLocation',
                          // searchable: true,
                          controller: Source,
                          // onOpen: () {
                          //   myFocusNode.requestFocus();
                          // },
                        ),),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          child: Text('DESTINATION LOCATION : '),
                          alignment: Alignment.topLeft,
                        ),
                        Flexible(child: BsSelectBox(
                          hintText: 'select DestinationLocation',
                          // searchable: true,
                          controller: Destination,
                          // onOpen: () {
                          //   myFocusNode.requestFocus();
                          // },
                        ),),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Container(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blueAccent
                  ),
                  onPressed: () {
                    LocChange ();
                  },
                  child: Text('Location Change',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
