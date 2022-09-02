import 'dart:convert';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'CJLogin.dart';
import 'Inward.dart';
import 'LOCICHANGE.dart';
import 'LOCMAP.dart';
import 'Out(RM/BOP).dart';
import 'package:http/http.dart' as http;

class OUT_2 extends StatefulWidget {
  const OUT_2({Key? key}) : super(key: key);

  @override
  State<OUT_2> createState() => _OUT_2State();
}

class _OUT_2State extends State<OUT_2> {

  var LSB_2;
  var PNO_2;
  var PNAME_2;
  var MDL_2;
  var QTY_2;
  late FocusNode myFocusNode_2;
  late FocusNode myFocusNode_3;
  var INO = TextEditingController();
  var QReq_1 = TextEditingController();
  var fifo;
  var fifoint;
  var FirstBarcode;


  BsSelectBoxController Customer = BsSelectBoxController();

  void Cust() async {
    var url="https://yjapi.larch.in/Home/fetchCustomer";
    var response=await http.get(Uri.parse(url));
    var data= jsonDecode(response.body);
    Customer.setOptions([
      for(int i=0;i<data.length;i++)
        BsSelectBoxOption(value: data[i]['Id'], text: Text('${data[i]['Value']}'))
    ]);
  }

  var BCODE_2 = TextEditingController();

  void BarDet_2() async {
    var url_1 = "https://yjapi.larch.in/Home/Pr_Fetch_BarcodeTag?Barcode=${BCODE_2.text}";
    var response = await http.get(Uri.parse(url_1));
    // print(response.body);
    var data_1 = jsonDecode(response.body);
    for (int j=0;j<data_1.length;j++)
    {
      if(data_1[j]['Format'] == '')
      {
        setState(() {
          LSB_2 = '${data_1[j]['UniqueBarcode']}';
          PNO_2 = '${data_1[j]['PartNo']}';
          PNAME_2 = '${data_1[j]['PartName']}';
          MDL_2 = '${data_1[j]['ModelCode']}';
          QTY_2 = '${data_1[j]['Qty']}';
          QReq_1.text = '${data_1[j]['Qty']}';
          fifo = '${data_1[j]['FIFO']}';
          fifoint = int.parse(fifo);
          print(fifoint);
          if (fifoint > 0){
            outwardwithfifo();
          }
        });
      }
      else{
        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              BCODE_2.text = '';
              myFocusNode_3.requestFocus();
              setState(() {
                LSB_2 = '';
                PNO_2 = '';
                PNAME_2 = '';
                MDL_2 = '';
                QTY_2 = '';
                QReq_1.text = '';
              });
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
  }

  void Status_2 () async {
    var url_2 = "https://yjapi.larch.in/Home/FGOutward?Barcode=${BCODE_2.text}&CustomerId=${Customer.getSelected()!.getValue()}&InvNo=${INO.text}&Qty=${QReq_1.text}&CreatedBy=${um_id}";
    var response = await http.get(Uri.parse(url_2));
    var data_2 = jsonDecode(response.body);
    for(int i=0;i<data_2.length;i++)
    {
      if(data_2[i]['Success'] != '')
      {
        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              BCODE_2.text = '';
              myFocusNode_3.requestFocus();
              setState(() {
                LSB_2 = '';
                PNO_2 = '';
                PNAME_2 = '';
                MDL_2 = '';
                QTY_2 = '';
                QReq_1.text = '';
              });
              Navigator.pop(context);
            },
            child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 15.0),));
        AlertDialog dialog = AlertDialog(
          title: Row(
            children: [
              Icon(Icons.cloud_done),
              SizedBox(width: 7.0,),
              Text('OUTWARD',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
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
              BCODE_2.text = '';
              myFocusNode_3.requestFocus();
              setState(() {
                LSB_2 = '';
                PNO_2 = '';
                PNAME_2 = '';
                MDL_2 = '';
                QTY_2 = '';
                QReq_1.text = '';
              });
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

  void outwardwithfifo() async {
    var url_3 = "https://yjapi.larch.in/Home/FIFO?Barcode=${BCODE_2.text}";
    var response = await http.get(Uri.parse(url_3));
    var data_3 = jsonDecode(response.body);
    Widget okbutton = OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: Colors.redAccent),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok',style: TextStyle(color: Colors.white,fontSize: 15.0),));
    AlertDialog _dialog = AlertDialog(
      title: Text('FIFO RECORDS AVAILABLE'),
      content: SingleChildScrollView(
        child: Container(
          // padding: new EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = data_3.length - 1; i >= 0; i--)
                Card(
                  margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.transparent,
                  shadowColor: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 13, 0, 3),
                    child: ListTile(
                      title: Text('Barcode : ${data_3[i]['UniqueBarcode'].toString()}' +
                            "\n" +
                            'Rack : ${data_3[i]['GRNNO'].toString()}' +
                            "\n" +
                            'Inward Quantity : ${data_3[i]['ERPCode'].toString()}' +
                            "\n" +
                            'Inward Date / Time : ${data_3[i]['PartNo'].toString()}' +
                            ' ' +
                            "\n"
                        ),
                      onTap: () {
                        FirstBarcode = "${data_3[i]['UniqueBarcode'].toString()}";
                        BCODE_2.text = FirstBarcode;
                        BarDet_2();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
            ],
          ),

        ),
      ),
      actions: [okbutton],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _dialog;
        });
    BCODE_2.text = '';
    myFocusNode_3.requestFocus();
    setState(() {
      LSB_2 = '';
      PNO_2 = '';
      PNAME_2 = '';
      MDL_2 = '';
      QTY_2 = '';
      QReq_1.text = '';
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    LSB_2 = '';
    PNO_2 = '';
    PNAME_2 = '';
    MDL_2 = '';
    QTY_2 = '';
    myFocusNode_2 = FocusNode();
    myFocusNode_3 = FocusNode();
    Cust();
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
                  Text('SALES  ',style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
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
                        child: Text('CUSTOMER : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: BsSelectBox(
                        hintText: 'select customer',
                        // searchable: true,
                        controller: Customer,
                        onClose: () {
                          myFocusNode_2.requestFocus();
                        },
                      ),),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('INVOICE NO : '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: TextFormField(
                        // readOnly: true,
                        controller: INO,
                        focusNode: myFocusNode_2,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (go){
                          myFocusNode_3.requestFocus();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                          prefixIcon: Icon(Icons.note_alt_sharp),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('BARCODE  :    '),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: TextFormField(
                        // readOnly: true,
                        controller: BCODE_2,
                        focusNode: myFocusNode_3,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (go){
                          BarDet_2();
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
            SizedBox(height: 30.0,),
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
                       Text('$LSB_2',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('PART NO : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$PNO_2',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('PART NAME : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$PNAME_2',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('MODEL : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$MDL_2',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  Row(children: [
                    Align(
                      child: Text('QUANTITY (Available) : ',style: TextStyle(color: Colors.black,fontSize: 15.0,),),
                      alignment: Alignment.topLeft,
                    ),
                     Text('$QTY_2',style: TextStyle(color: Colors.blueAccent,fontSize: 15.0,),),
                  ],),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.fromLTRB(13, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text('QUANTITY (Req) : ',style: TextStyle(fontSize: 15.0,),),
                        alignment: Alignment.topLeft,
                      ),
                      Flexible(child: TextFormField(
                        // readOnly: true,
                        onChanged: (text) {
                          print('${QReq_1.text}');
                        },
                        controller: QReq_1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                        ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                      ),
                    ],
                  ),
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
                  Status_2 ();
                },
                child: Text('Complete',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
