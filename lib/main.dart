import 'package:flutter/material.dart';
import 'package:fpt/admin.dart';
import 'package:fpt/createUser.dart';
import 'package:fpt/model/db_handler.dart';
import 'package:fpt/model/db_model.dart';
import 'package:fpt/useQr.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyid = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController passwordTc = TextEditingController();
  bool visible = true;
  bool tapped = false;
  late bool newuser;
  late SharedPreferences sp;
  var checkUserType;
  bool isLoginTrue = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    check_value_login();
  }

  login() async {
    // Login Funtion
    var response = await dbHandler().getUserAuth(dbModel(
        companyId: companyid.text,
        username: username.text,
        password: passwordTc.text));
    if (response == true) {
      if (checkUserType == 'x1234') {
        // Checking UserType Here
        Get.to(AdminScanner());
      } else {
        Get.off(UserQrCodeScanner());
      }
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipPath(
                  clipper: Custom(),
                  child: Container(
                    color: Colors.cyan,
                    height: 200,
                  ),
                ),
                Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Image(
                      image: AssetImage("assets/images/logoftp.jpg"),
                      height: 100,
                    )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          TextFormField(
                            controller: companyid,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.account_circle),
                              labelText: 'CompanyId',
                              labelStyle: TextStyle(
                                  color: Colors.cyan[600],
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
                              suffixIcon: Icon(Icons.email),
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                  color: Colors.cyan[600],
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
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.cyan[600],
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
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    tapped = true;
                                  });
                                  final user = username.text.trim();
                                  final password = passwordTc.text.trim();
                                  final id = companyid.text.trim();
                                  checkUserType = companyid.text.trim();
                                  sp.setBool('login_flag', false);
                                  sp.setString("username", user);
                                  login();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.cyan, // Change the button color here
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: tapped
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: TextButton(
                                onPressed: () {
                                  Get.to(createUser());
                                },
                                child: Text("CreateUser")),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void check_value_login() async {
    sp = await SharedPreferences.getInstance();
    newuser = (sp.getBool('login_flag') ?? true);
    if (newuser == false) {
      if (checkUserType == 'x12345') {
        Get.to(() => AdminScanner());
      } else {
        Get.off(() => UserQrCodeScanner());
      }
    }
  }

  void dispose() {
    username.dispose();
    companyid.dispose();
    passwordTc.dispose();
    super.dispose();
  }
}

class Custom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    // path.lineTo(0.0, size.height/2.5);
    // path.lineTo(size.width+900, 0.0);
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
