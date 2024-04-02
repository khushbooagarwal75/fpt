// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fpt/display.dart';
// import 'package:fpt/editPage.dart';
import 'package:fpt/model/db_handler.dart';
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

  String? username;
  late SharedPreferences spget;

  @override
  void initState() {
    // TODO: implement initState
    getvalue();
    super.initState();

  }

  void getvalue() async {
    spget = await SharedPreferences.getInstance();
    setState(() {
      username = spget.getString("username");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.cyan,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
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
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Place the Qr code in the Area",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Scanning will be Started Automatically",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  )),
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
                                productNameValue == null? SizedBox(height: 20,):
                                Column(
                                  children: [
                                    Text("ProductName",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text('$productNameValue'),
                                  ],
                                ),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: ElevatedButton(
                                onPressed: () {
                                    Get.to(() => editPage(),
                                       arguments: {
                                         "barcode": code,
                                         "username": username,
                                       }
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors.cyan.shade300, // Change the button color here
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
        _screenOpened = false;
      });
    }
    final data = await dbHandler().fetchData('$code');
    setState(() {
      productNameValue = data['productNameValue'];
    });
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}


