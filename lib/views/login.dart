import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import 'home.dart';



final auth =FirebaseAuth.instance;

void main()  {
  runApp(MaterialApp(
    home:auth.currentUser == null?Login():Home(),
  ),
  );
}
class Login extends StatelessWidget {
  AuthService authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Form(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login Your Account",
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: authService.email,
                decoration: InputDecoration(
                  hintText: "E-Mail",
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: authService.password,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
               // Apply password validation
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 70)),
                  onPressed: () {
                    if(authService.email != "" && authService.password != ""){
                      authService.LoginUser(context);
                    }
                  },
                  child: Text("LogIn")),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text("Don't have an account? SignUp"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin()));
                  },
                  child: Text("LogIn As An Admin"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// class AdminLogin extends StatelessWidget {
//   AuthService authService = AuthService();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//         child: Form(
//
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Login Your Admin Account",
//                 style: TextStyle(
//                     color: Colors.lightBlue,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               TextFormField(
//                 controller: authService.adminEmail,
//                 decoration: InputDecoration(
//                   hintText: "E-Mail",
//                   hintStyle: TextStyle(
//                     color: Colors.blue,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               TextFormField(
//                 controller: authService.adminPassword,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   hintStyle: TextStyle(
//                     color: Colors.blue,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                  // Apply admin password validation
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               ElevatedButton(
//                   style: TextButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: 70)),
//                   onPressed: () {
//                     if(authService.adminEmail != "" && authService.adminPassword != ""){
//                       authService.adminLogin(context);
//                     }
//                   },
//                   child: Text("LogIn")),
//               TextButton(
//                 onPressed: () {
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanel()));
//                 },
//                 child: Text("Not Admin?"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class Register extends StatelessWidget {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Form(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register Your Account",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: authService.name,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: authService.email,
                decoration: InputDecoration(
                  hintText: "E-Mail",
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: authService.password,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 70)),
                  onPressed: () {
                    if(authService.email != "" && authService.password != ""){
                      authService.RegisterUser(context);
                    }
                  },
                  child: Text("Register")),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text("Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}