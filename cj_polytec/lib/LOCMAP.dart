import 'dart:convert';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';

import 'CJLogin.dart';
import 'Inward.dart';
import 'LOCICHANGE.dart';
import 'Out(FG).dart';
import 'Out(RM/BOP).dart';
import 'package:http/http.dart' as http;

class LOCMAP extends StatefulWidget {
  const LOCMAP({Key? key}) : super(key: key);

  @override
  State<LOCMAP> createState() => _LOCMAPState();
}

class _LOCMAPState extends State<LOCMAP> {

  var LMLSB;
  var LMPNO;
  var LMPNAME;
  var LMMDL;
  var LMQTY;
  late FocusNode myFocusNode_1;

  BsSelectBoxController LMRack = BsSelectBoxController();

  void LocRack () async {
    var url="http://yjapi.larch.in/Home/FetchRack";
    var response=await http.get(Uri.parse(url));
    var data= jsonDecode(response.body);
    LMRack.setOptions([
      for(int i=0;i<data.length;i++)
        BsSelectBoxOption(value: data[i]['Id'], text: Text('${data[i]['Value']}'))
    ]);
  }


  var LMBCODE = TextEditingController();

  void BarDet_3() async {
    var url_1 = "https://yjapi.larch.in/Home/Pr_Fetch_BarcodeTag?Barcode=${LMBCODE.text}";
    var response = await http.get(Uri.parse(url_1));
    // print(response.body);
    var data_1 = jsonDecode(response.body);
    for (int j=0;j<data_1.length;j++)
    {
      if(data_1[j]['Format'] == '')
        {
          setState(() {
            LMLSB = '${data_1[j]['UniqueBarcode']}';
            LMPNO = '${data_1[j]['PartNo']}';
            LMPNAME = '${data_1[j]['PartName']}';
            LMMDL = '${data_1[j]['ModelCode']}';
            LMQTY = '${data_1[j]['Qty']}';
          });
        }
      else{
        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              LMBCODE.text = '';
              myFocusNode_1.requestFocus();
              // setState(() {
              //   LMLSB = '';
              //   LMPNO = '';
              //   LMPNAME = '';
              //   LMMDL = '';
              //   LMQTY = '';
              // });
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
          content: Text('${data_1[j]['Format']}'),
          actions: [okbutton],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
      }
    }
    // Status();
  }

  void LocMap () async {
    var url_2 = "https://yjapi.larch.in/Home/LocationTransfer?RackTo=${LMRack.getSelected()!.getValue()}&Barcode=${LMBCODE.text}&CreatedBy=$um_id";
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
              Text('LOCATION MAPPING',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
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
              Text('LOCATION MAPPING',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
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
   LMLSB = '';
   LMPNO = '';
   LMPNAME = '';
   LMMDL = '';
   LMQTY = '';
   LocRack ();
   myFocusNode_1 = FocusNode();
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
        child: Column(
          children: [
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Row(
                children: [
                  Icon(Icons.keyboard_double_arrow_right),
                  Text('LOCATION MAPPING ',style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('RACK : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: BsSelectBox(
                        hintText: 'select Rack',
                        // searchable: true,
                        controller: LMRack,
                        onClose: () {
                          myFocusNode_1.requestFocus();
                        },
                      ),),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('BARCODE : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: TextFormField(
                        // readOnly: true,
                        controller: LMBCODE,
                        focusNode: myFocusNode_1,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (go){
                          BarDet_3();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                          prefixIcon: Icon(Icons.qr_code_scanner_outlined),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Text('LAST SCANNED BARCODE : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                        alignment: Alignment.topLeft,
                      ),
                       Text('$LMLSB',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('PART NO : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$LMPNO',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('PART NAME : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$LMPNAME',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('MODEL : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$LMMDL',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('QUANTITY : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$LMQTY',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
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
                  LocMap();
                },
                child: Text('Location Map',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
