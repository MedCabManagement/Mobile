import 'package:flutter/material.dart';
import 'package:patient/models/account.dart';
import 'package:patient/views/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final user = User();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordObscured = true;
  bool inputFieldEnabled = true;
  bool changePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("MDC Management Application",
            style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        children: <Widget>[
          CircleAvatar(
            child: Image.asset('assets/app_logo_icon.png'),
            radius: 100,
          ),
          const SizedBox(height: 30.0),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "E-mail",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            enabled: inputFieldEnabled,
          ),
          const SizedBox(height: 15.0),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  passwordObscured
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
                onPressed: () {
                  setState(() {
                    passwordObscured = !passwordObscured;
                  });
                },
              ),
            ),
            enabled: inputFieldEnabled,
            obscureText: passwordObscured,
          ),
          const SizedBox(height: 20.0),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ElevatedButton(
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: inputFieldEnabled
                      ? () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          setState(() {
                            inputFieldEnabled = false;
                          });

                          Future((() async {
                            final email = emailController.text;
                            final password = passwordController.text;
                            final statusCode =
                                await user.login(email, password);
                            if (statusCode == 200) {
                              Navigator.of(context).popUntil(
                                  (route) => Navigator.of(context).canPop());
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Home(user),
                              ));
                            } else {
                              setState(() {
                                inputFieldEnabled = true;
                              });
                            }
                          }));
                        }
                      : null)),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
