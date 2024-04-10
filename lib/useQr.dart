import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpt/display.dart';
import 'package:fpt/loginTry.dart';
import 'package:fpt/model/db_handler.dart';
import 'package:fpt/screen2.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'editPage.dart';

class UserQrCodeScanner extends StatefulWidget {
  const UserQrCodeScanner({super.key});

  @override
  State<UserQrCodeScanner> createState() => _UserQrCodeScannerState();
}

class _UserQrCodeScannerState extends State<UserQrCodeScanner> {
  @override
  var bg_color = Color(0xfffafafa);
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;
  String? productNameValue;
  String? code;
  String? role;
  late SharedPreferences spget;
  late String? stname;

  @override
  void initState() {
    // TODO: implement initState
    getuserrole();
    super.initState();
  }

  void getuserrole() async {
    spget = await SharedPreferences.getInstance();
    setState(() {
      role = spget.getString('role');
      stname = spget.getString("username");
    });
  }

  void fetch_value() async {
    await dbHandler().fetchdataProduct(code).then((value) {
      var productdesc;
      String CheckCode = '';
      setState(() {
        CheckCode = value[0]['barCodeNo'];
        productNameValue = value[0]['productName'];
        productdesc = value[0]['productionDescription'];
        // print(productdesc);
        // print(role);
      });

      if (role != 'Production' && productdesc == null) {
        setState(() {
          code = null;
        });
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 350,
                height: 80,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info, size: 40, color: Colors.red),
                    Text(
                      CheckCode,
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Unauthorized Barcode Number',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _screenOpened = true;
                        });

                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[900], // Background color
                      ),
                      child: Text("OK", style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        );
      }
      else {
        print(role);
      }
    }).onError((error, stackTrace) {
      setState(() {
        code = null;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.cyan.shade900,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            title: Column(
              children: [
                Text(
                  'Finished Part Transfer',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              Text(
                stname!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Place the Qr code in the Area",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Scanning will be Started Automatically",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Expanded(
                  // flex: 3,
                  child: SizedBox(
                // width:200,
                // height: 200,
                child: Stack(
                  children: [
                    MobileScanner(
                      allowDuplicates: false,
                      controller: cameraController,
                      onDetect: _foundBarcode,
                    ),
                    QRScannerOverlay(
                      overlayColor: bg_color,
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                width: double.infinity,
                // color: Colors.grey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      code == null
                          ? SizedBox(
                              child: Text("Scan Data Will Display Here"),
                            )
                          : Column(
                              children: [
                                Text("BarcodeNo",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text('$code'),
                                Column(
                                  children: [
                                    productNameValue == null
                                        ? SizedBox(
                                            height: 20,
                                          )
                                        : Column(
                                            children: [
                                              Text("ProductName",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('$productNameValue'),
                                            ],
                                          ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        role == "Production"
                                            ? Get.to(() => editPage(),
                                                arguments: {
                                                    "barcode": code,
                                                    "username": stname,
                                                  })
                                            : Get.to(() => DisplayPage(),
                                                arguments: {
                                                    "barcode": code,
                                                    "username": stname,
                                                  });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.cyan.shade900
                                            .withOpacity(
                                                0.5), // Change the button color here
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: role=="production"?Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ):Text(
                                        'View',
                                        style: TextStyle(
                                          fontSize: 25,
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
                ),
              )),
            ],
          ),
        ));
  }

  void _foundBarcode(Barcode barcode, MobileScannerArguments? args) async {
    if (!_screenOpened) {
      code = barcode.rawValue ?? "---";
      _screenOpened = true;
      setState(() {
        debugPrint('Barcode found! $code');
        fetch_value();
        _screenOpened = false;
      });
    }

    //   final data = await dbHandler().fetchData('$code');
    //   setState(() {
    //     productNameValue = data['productNameValue'];
    //   });
    // }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
