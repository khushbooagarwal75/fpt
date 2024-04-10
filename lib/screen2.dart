import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpt/model/db_handler.dart';
import 'package:fpt/useQr.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeScan extends StatefulWidget {
  const BarcodeScan({super.key});

  @override
  State<BarcodeScan> createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  // var username;
  // var userCompanyID;

  @override
  void initState() {
    // fetchsingleuser();
    super.initState();
  }

  // void fetchsingleuser() async {
  //   SharedPreferences sharedPref = await SharedPreferences.getInstance();
  //   userCompanyID = sharedPref.getString('companyid');
  //
  //   await dbHandler().fetchUserSingleData(userCompanyID).then((value) {
  //     setState(() {
  //       username = value != null ? value[0]['name'] ?? '' : '';
  //       sharedPref.setString("userprofilename", username);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.cyan.shade900,
        body: Center(
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 60),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                height: 460,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Scan QR Code",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset("assets/images/barcode1.png"),
                          ),
                          Positioned(top: 0, left: 0, child: _buildBorder()),
                          Positioned(top: 0, right: 0, child: _buildBorder()),
                          Positioned(bottom: 0, left: 0, child: _buildBorder()),
                          Positioned(
                              bottom: 0, right: 0, child: _buildBorder()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => UserQrCodeScanner());
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
                          child: Text(
                            'Scan QR/Barcode',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildBorder() {
  return Container(
    width: 15,
    height: 15,
    color: Colors.cyan.shade900,
  );
}
