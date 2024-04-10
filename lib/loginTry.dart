import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fpt/admin.dart';
import 'package:fpt/createUser.dart';
import 'package:fpt/display.dart';
import 'package:fpt/model/db_handler.dart';
import 'package:fpt/model/db_model.dart';
import 'package:fpt/screen2.dart';
import 'package:fpt/storePage.dart';
import 'package:fpt/useQr.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TryLogin extends StatefulWidget {
  TryLogin({super.key});

  @override
  State<TryLogin> createState() => _TryLoginState();
}

class _TryLoginState extends State<TryLogin> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController companyId = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController passwordTc = TextEditingController();
  bool visible = true;
  bool tapped = false;
  late bool newuser;
  late SharedPreferences sp;
  var checkUserType;
  var selectedValue;
  final List<String> items = ['Production', 'QA/QC', 'Store','Admin'];
  bool isLoginTrue = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      selectedValue = items.first;
    });
    super.initState();
    check_value_login();
  }

  login() async {
    // Login Funtion
    var response = await dbHandler().getUserAuth(dbModel(
        companyId: companyId.text,
        username: username.text,
        password: passwordTc.text,
        role: selectedValue));

    if (response == true) {
      if (checkUserType == 'Admin') {
        // Checking UserType Here
        Get.to(()=>AdminScanner());
        setState(() {
          tapped=false;
        });
      } else {
        sp.setBool("login_flag", false);
        sp.setString('username', username.text);
        sp.setString('companyid', companyId.text);
        sp.setString("role", selectedValue.toString());
        Get.off(()=>BarcodeScan());
        setState(() {
          tapped=false;
        });
      }
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: Custom(),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.cyan.shade900,
                  // gradient: LinearGradient(
                  //     colors:[Colors.cyan])
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Finished Part Transfer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        letterSpacing: 1.2,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // CircleAvatar(
                  //   radius: 58,
                  //     child: Image.asset("assets/images/logo_ftp.png",),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 140,
              left: 20,
              right: 20,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 550,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: companyId,
                              decoration: InputDecoration(
                                isDense: true,
                                suffixIcon: Icon(Icons.account_circle),
                                labelText: 'CompanyId',
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
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: username,
                              decoration: InputDecoration(
                                isDense: true,
                                suffixIcon: Icon(Icons.email),
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                    color: Colors.cyan[900],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black87, width: 3),
                                    borderRadius: BorderRadius.circular(
                                        20) // Change the border color here
                                    ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        20) // Change the border color here as well
                                    ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter  Username';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: passwordTc,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.cyan[900],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                suffixIcon: IconButton(
                                  icon: Icon(visible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      visible = !visible;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black87, width: 3),
                                    borderRadius: BorderRadius.circular(
                                        20) // Change the border color here
                                    ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        20) // Change the border color here as well
                                    ),
                              ),
                              obscureText: visible,
                              obscuringCharacter: "*",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter  password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Role",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.cyan.shade900,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 230, // Set width as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust border radius as needed
                                    border: Border.all(
                                        color:
                                            Colors.black), // Set border color
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 10),
                                    child: DropdownButton<String>(
                                      value: selectedValue,
                                      iconSize: 24,
                                      isDense: true,
                                      elevation: 10,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontSize: 16),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.transparent,
                                      ),
                                      // isDense: true,// Set default value
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedValue = value;
                                        });
                                        print(value);
                                      },
                                      items: items.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              // Change text color
                                              fontSize: 16, // Change font size
                                              fontWeight: FontWeight
                                                  .bold, // Change font weight
                                              // Add any other styles you need
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      tapped = true;
                                    });
                                    final user = username.text.trim();
                                    final password = passwordTc.text.trim();
                                    final id = companyId.text.trim();
                                    checkUserType =selectedValue;
                                    login();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan.shade900
                                      .withOpacity(
                                          0.6), // Change the button color here
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: tapped
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 0.2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: TextButton(
                                  onPressed: () {
                                    Get.to(createUser());
                                  },
                                  child: Text(
                                    "Create User",
                                    style: TextStyle(
                                        color: Colors.cyan.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        letterSpacing: 0.2),
                                  )),
                            ),
                            isLoginTrue
                                ? const Text(
                                    "Username or password is incorrect",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: CircleAvatar(
                    radius: 80,
                    child: Image.asset(
                      "assets/images/logo_ftp.png",
                    )))
          ],
        ),
      ),
    );
  }

  void check_value_login() async {
    sp = await SharedPreferences.getInstance();
    newuser = (sp.getBool('login_flag') ?? true);
    if (newuser == false) {
      Get.off(() => BarcodeScan());
    }
  }

  void dispose() {
    username.dispose();
    companyId.dispose();
    passwordTc.dispose();
    super.dispose();
  }
}

class Custom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    // var path= new Path();
    // path.lineTo(size.width+2700,size.height/2);
    // path.lineTo(size.width, size.height);
    // path.close();
    // return path;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.8)
      ..lineTo(0, size.height * 0.46)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
