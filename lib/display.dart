import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpt/loginTry.dart';
import 'package:fpt/main.dart';
import 'package:fpt/model/db_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late SharedPreferences spget;
  late String? stname;
  String barcode = Get.arguments['barcode'];
  String? productName;
  String? manufacturer;
  String? dimensions;
  String? description;
  String? review;

  var ScanValue;
  var barCodeValue;
  String? manufacturing;
  String? productDimension;
  String? remark;
  String? productIdvalue;
  String? role;
  String? production_mail;
  String? qc_mail;
  String? store_mail;
  String? username;
  String? CheckByUser_production;
  String? CheckByUser_QA;
  String? userCompanyID;
  var updateId;
  TextEditingController deniedProduct=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barCodeValue = Get.arguments['barcode'];
    getvalue();
    getdata();
  }
  void getvalue() async {
    spget = await SharedPreferences.getInstance();
    setState(() {
      stname = spget.getString("username");
    });
  }
  checkuserid() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    userCompanyID = sharedPref.getString('companyid');
  }
  void getdata() async {
    await dbHandler().fetchdataProduct(barcode).then(
          (value) {
        setState(() {
          checkuserid();
          ScanValue = value;
          updateId = ScanValue != null ? ScanValue[0]['id'] ?? '' : '';
          productName =
          ScanValue != null ? ScanValue[0]['productName'] ?? '' : '';
          manufacturer =
          ScanValue != null ? ScanValue[0]['manufacturingPlant'] ?? '' : '';
          dimensions =
          ScanValue != null ? ScanValue[0]['productDiminsion'] ?? '' : '';
          description = ScanValue != null
                  ? ScanValue[0]['productionDescription'] ?? ''
                  : ' ';
          review = ScanValue != null
                  ? ScanValue[0]['productionReview'] ?? ''
                  : ' ';

        });
      },
    ).onError((error, stackTrace) {
      print(error);
    });
  }
  getemailvalue() async {
    await dbHandler().fetchUseremailData(CheckByUser_production,CheckByUser_QA,userCompanyID).then(
          (value) {
        print("inside pdf");
        // print(value);
        print(value[0]['email']);
        production_mail=value[0]['email'].toString().trim();
        qc_mail=value[0]['email'].toString().trim();
        store_mail=value[0]['email'].toString().trim();
        print(value[1]['email']);

        CheckByUser_production = ScanValue != null
            ? ScanValue[0]['productionCheckUSerId'] ?? ''
            : ' ';
        // if(role=='QA/QC'){
        CheckByUser_QA = ScanValue != null
            ? ScanValue[0]['qualityCheckUserID'] ?? ''
            : ' ';
        // }
        getemailvalue();

      },
    ).onError((error, stackTrace) {
      print(error);
    });
  }


//   void fetchdata() async {
//     final data = await dbHandler().fetchdataProduct(barcode).then(
//             (value) async{
//               late SharedPreferences spgetrole;
//               spgetrole = await SharedPreferences.getInstance();
//
//               setState(() {
//                 role = spgetrole.getString('role');
//                 username=spgetrole.getString('');
//
//                 userCompanyID = spgetrole.getString('companyid');
//
//                 ScanValue = value;
//                 productIdvalue = ScanValue != null ? ScanValue[0]['productId'] ?? '' : '';
// // print(productIdvalue);
//                 productName =
//                 ScanValue != null ? ScanValue[0]['productName'] ?? '' : '';
//                 manufacturing =
//                 ScanValue != null ? ScanValue[0]['manufacturingPlant'] ?? '' : '';
//                 productDimension =
//                 ScanValue != null ? ScanValue[0]['productDiminsion'] ?? '' : '';
//                 description = ScanValue != null
//                     ? ScanValue[0]['productionDescription'] ?? ''
//                     : ' ';
//                 remark =
//                 ScanValue != null ? ScanValue[0]['productionReview'] ?? '' : ' ';
//
//                 CheckByUser_production = ScanValue != null
//                     ? ScanValue[0]['productionCheckUSerId'] ?? ''
//                     : ' ';
//                 // if(role=='QA/QC'){
//                 CheckByUser_QA = ScanValue != null
//                     ? ScanValue[0]['qualityCheckUserID'] ?? ''
//                     : ' ';
//                 // }
//                 getemailvalue();
//
//               });
//     setState(() {
//       productName = data['productNameValue'];
//       manufacturer = data['manufacturingPlantValue'];
//       dimensions = data['productDiminsionValue'];
//       // description = data['Description'];
//       // review = data['Review'];
//     });
//   }
//         }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.cyan.shade900,
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                stname!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: () {
                spget.setBool('login_flag', true);
                dispose();
                Get.off(() => TryLogin());
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
                size: 27,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "Product Details",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Barcode Details: ',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            Get.arguments['barcode'],
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      productName != null
                          ? Row(
                              children: [
                                Text(
                                  'Product Name: ',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  productName!,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 8.0),
                      dimensions != null
                          ? Row(
                              children: [
                                Text(
                                  'Dimensions: ',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  dimensions!,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 8.0),
                      manufacturer != null
                          ? Column(
                              children: [
                                Text(
                                  'Manufacturing Plant: ',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  manufacturer!,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 8.0),
                      description != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                description != null
                                    ? Text(
                                        'Description:',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                                SizedBox(height: 5.0),
                                Text(
                                  description!,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 16.0),
                      review == null
                          ? SizedBox(
                              height: 0,
                            )
                          : Column(
                              children: [
                                Text(
                                  'Review:',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  review!,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 10,),
                      role!="production"?Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        alignment: Alignment.bottomCenter,
                                        title: Text('Product Status'),
                                        content: Text('Approved.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan.shade900.withOpacity(
                                      0.5), // Change the button color here
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child:Text(
                                  'Approve',
                                  style: TextStyle(
                                    fontSize: 25,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return  Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                SizedBox(height: 10,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 0),
                                                  child: TextFormField(
                                                    controller: deniedProduct,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      suffixIcon: Icon(Icons.feedback),
                                                      labelText: 'Remark',
                                                      labelStyle: TextStyle(
                                                          color: Colors.cyan[900],
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                        borderSide: BorderSide(
                                                            color: Colors.black87, width: 3),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                        borderSide: BorderSide(
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter  CompanyId';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 0),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      onPressed: () async {

                                                        var connectivityResult = await Connectivity().checkConnectivity();
                                                        if (connectivityResult == ConnectivityResult.none) {
                                                          // No internet connection
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              title: Text('No Internet Connection'),
                                                              content: Text('Please check your internet connection.'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Navigator.pop(context),
                                                                  child: Text('OK'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          // _launchEmail();
                                                          Send_mail();

                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.cyan.shade900.withOpacity(
                                                            0.5), // Change the button color here
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 0, vertical: 5),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child:Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          letterSpacing: 0.5,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan.shade900.withOpacity(
                                      0.5), // Change the button color here
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child:Text(
                                  'Deny',
                                  style: TextStyle(
                                    fontSize: 25,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ):SizedBox(height: 0,),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void Send_mail() {
    var Service_id = 'service_wv0fuqf',
        Template_id = 'template_cnk3plf',
        User_id = 'Fi_N4AtsfrugumPNL';
    var remarkText = remark;
    print("$production_mail "+"inside");
    // print(productId);
    print(qc_mail);
    var s = http.post(Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'origin': 'http:localhost',
          'Content-Type': 'application/json'
        },

        body: jsonEncode({
          'service_id': 'service_wv0fuqf',
          'user_id': 'Fi_N4AtsfrugumPNL',
          'template_id': 'template_cnk3plf',
          'template_params': {
            'reply_to_cc': "deekanojiya@gmail.com",
            'reply_to_BCC': "merofo5609@adstam.com",
            'to_name': "chiraj  mehta",
            'reply_to':'$production_mail',
            'ProductName_head': productName,
            'from_Departmentname': role,
            'barcodeno': barCodeValue,
            'ProductID': productIdvalue,
            'ProuductName': productName,
            'remark':remarkText ,
            'to_email': role=='Store'? store_mail:qc_mail,
            'from_Department':role,
          }

        }


        ));
    // print(productName);

  }

}