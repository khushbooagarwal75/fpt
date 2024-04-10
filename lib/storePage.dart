import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.cyan.shade900,
          elevation: 0,
          title: Text(
            'Finished Part Transfer',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          automaticallyImplyLeading: false,

          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "stname",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: () {
                // spget.setBool('login_flag', true);
                // dispose();
                // Get.off(() => TryLogin());
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
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 60),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 400,
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Text("Product Review",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  SizedBox(height: 50,),
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
                                  title: Text('Product Approved'),
                                  content: Text('We are happy that you are satisfied with product.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Add button functionality here
                                        // For demo, just close the dialog box
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },);
                          // Get.to(()=>UserQrCodeScanner());
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
                          // Get.to(()=>UserQrCodeScanner());
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return BottomForm();
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class BottomForm extends StatelessWidget {
  TextEditingController deniedProduct=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    onPressed: () {
                      // Get.to(()=>UserQrCodeScanner());
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
  }
}