import 'package:flutter/material.dart';
import 'package:fpt/display.dart';
import 'package:fpt/loginTry.dart';
import 'package:fpt/model/db_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editPage extends StatefulWidget {
  const editPage({super.key});

  @override
  State<editPage> createState() => _editPageState();
}

class _editPageState extends State<editPage> {
  late SharedPreferences spget;
  late String? stname;
  String? role;
  TextEditingController description = TextEditingController();
  TextEditingController review = TextEditingController();
  String barcode = Get.arguments['barcode'];
  final _formKey = GlobalKey<FormState>();
  String? productname, manufacturer, dimensions;

  var ScanValue;
  var barCodeValue;
  var updateId;
  var userCompanyID;

  // void fetchdata() async {
  //   final data = await dbHandler().fetchData(barcode);
  //   setState(() {
  //     productname = data['productNameValue'];
  //     manufacturer = data['manufacturingPlantValue'];
  //     dimensions = data['productDiminsionValue'];
  //   });
  // }
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

  void getuserrole() async {
    spget = await SharedPreferences.getInstance();
    setState(() {
      role = spget.getString('role');
      stname = spget.getString("username");
    });
  }

  void getdata() async {
    await dbHandler().fetchdataProduct(barcode).then(
      (value) {
        setState(() {
          checkuserid();
          ScanValue = value;
          updateId = ScanValue != null ? ScanValue[0]['id'] ?? '' : '';
          productname =
              ScanValue != null ? ScanValue[0]['productName'] ?? '' : '';
          manufacturer =
              ScanValue != null ? ScanValue[0]['manufacturingPlant'] ?? '' : '';
          dimensions =
              ScanValue != null ? ScanValue[0]['productDiminsion'] ?? '' : '';
          description = TextEditingController(
              text: ScanValue != null
                  ? ScanValue[0]['productionDescription'] ?? ''
                  : ' ');
          review = TextEditingController(
              text: ScanValue != null
                  ? ScanValue[0]['productionReview'] ?? ''
                  : ' ');
        });
      },
    ).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getvalue();
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.cyan.shade900,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text(
            'Finished Part Transfer',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Edit Information",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Text("Barcode No: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                            // SizedBox(width: 5,),
                            Text(Get.arguments["barcode"],
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        productname == null
                            ? SizedBox(
                                height: 0,
                              )
                            : Row(
                                children: [
                                  Text(
                                    "Product Name: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(productname!,
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                        manufacturer == null
                            ? SizedBox(
                                height: 0,
                              )
                            : Row(
                                children: [
                                  Text(
                                    "Manufacturer: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(manufacturer!,
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                        dimensions == null
                            ? SizedBox(
                                height: 0,
                              )
                            : Row(
                                children: [
                                  Text(
                                    "Dimensions: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(dimensions!,
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: TextFormField(
                          maxLines: 3,
                          controller: description,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.feedback),
                            labelText: 'Description',
                            labelStyle: TextStyle(
                                color: Colors.cyan[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black87, width: 3),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter  Description';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: TextFormField(
                          controller: review,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.account_box),
                            labelText: 'Review',
                            labelStyle: TextStyle(
                                color: Colors.cyan[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black87, width: 3),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter  review';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await dbHandler()
                                .updateproduct(updateId, description!.text,
                                    review!.text, userCompanyID)
                                .then((value) {
                              // Handle the result if needed
                            });
                            Get.off(() => DisplayPage(), arguments: {
                              "barcode": barcode,
                              "desc": description.text.toString(),
                              "review": review.text.toString(),
                            });
                            //     arguments: {"username": Get.arguments["username"]});
                          }
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.cyan.shade900.withOpacity(0.5),
                            // Change the button color here
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          );
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
