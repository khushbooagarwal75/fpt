import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpt/main.dart';
import 'package:fpt/model/db_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalue();
    fetchdata();
  }

  void getvalue() async {
    spget = await SharedPreferences.getInstance();
    setState(() {
      stname = spget.getString("username");
    });
  }

  void fetchdata() async {
    final data = await dbHandler().fetchData(barcode);
    setState(() {
      productName = data['productNameValue'];
      manufacturer = data['manufacturingPlantValue'];
      dimensions = data['productDiminsionValue'];
      description = data['Description'];
      review = data['Review'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.cyan,
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
                Get.off(() => Login());
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
            return Container(
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
                    Row(
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
                        : SizedBox(height: 8.0),
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
                        : SizedBox(height: 8.0),
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
                        : SizedBox(height: 8.0),
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
                        : SizedBox(height: 16.0),
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
                          )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
