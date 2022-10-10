import 'package:eltraingraph/index_page.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyAppColors.BG_COLOR,
        body: MediaQuery.of(context).size.width > MyResponsive.PHONEWIDTHMAX
            ? Row(
                children: const [
                  Flexible(
                    flex: 1,
                    child: CreateSplashScreen(),
                  ),
                  Flexible(
                    flex: 1,
                    child: LoginCard(),
                  ),
                ],
              )
            : Stack(
                children: const [CreateSplashScreen(), LoginCard()],
              ));
  }
}

class CreateSplashScreen extends StatelessWidget {
  const CreateSplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MyAppColors.PRIMARY_COLOR,
        boxShadow: [
          BoxShadow(
            color: MyAppColors.SHADOW_COLOR,
            blurRadius: 8,
            offset: Offset(4, 0), // Shadow position
          ),
        ],
      ),
      // color: Colors.deepOrange,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: const DecorationImage(
                      image: AssetImage("assets/kai.jpg"), fit: BoxFit.cover)),
            ),
          ),
          Center(
              child: MediaQuery.of(context).size.width >=
                      MyResponsive.PHONEWIDTHMAX
                  ? SizedBox(
                      width: 300,
                      child: Text(
                        MyStaDat.APPTITLE_LONG,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            letterSpacing: 7.5,
                            fontSize: 54,
                            fontWeight: FontWeight.w700,
                            color: MyAppColors.FONT_LIGHT_COLOR),
                      ),
                    )
                  : const SizedBox()),
        ],
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        createLogo(),
        const SizedBox(height: 15),
        Text(
          MyStaDat.APPTITLE,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              letterSpacing: 4,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: MyAppColors.ACCENT_COLOR),
        ),
        const SizedBox(height: 25),
        Card(
          // decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(color: Colors.grey),
          //     borderRadius: BorderRadius.circular(5)),
          margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          // padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
          // color: Color.fromARGB(255, 224, 224, 222),
          elevation: 3,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 15),
                Text("Please sign in to continue.",
                    style:
                        TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                const SizedBox(height: 15),
                const TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.arrow_forward_ios),
                      // suffixIcon: Icon(Icons.check),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(8)),
                      labelText: "Username",
                      // labelStyle: TextStyle(color: Colors.green),
                      // hintText: "hint text",
                      // focusedBorder: UnderlineInputBorder(
                      //     borderSide:
                      //         BorderSide(color: Colors.blueAccent)),
                      prefixIcon: Icon(Icons.account_box_rounded)),
                ),
                const SizedBox(height: 20),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.arrow_forward_ios),
                      // suffixIcon: Icon(Icons.check),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(8)),
                      labelText: "Password",
                      // labelStyle: TextStyle(color: Colors.purple),
                      // hintText: "hint text",
                      // focusedBorder: UnderlineInputBorder(
                      //     borderSide:
                      //         BorderSide(color: Colors.blueAccent)),
                      prefixIcon: Icon(Icons.key)),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 35,
                          child: ElevatedButton.icon(
                            label: const Text("Sign In"),
                            icon: const Icon(Icons.login),
                            onPressed: () {
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const IndexPage(),
                                      // builder: (context) => const SliverIndexPage(),
                                    ));
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("All rights reserved   ",
                style: TextStyle(
                    fontSize: 11,
                    color: MyAppColors.FONT_LIGHT_COLOR,
                    fontWeight: FontWeight.w500)),
            Text("Elsicom 2022",
                style: TextStyle(
                    fontSize: 11,
                    color: MyAppColors.ACCENT_COLOR,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 70),
      ]),
    );
  }

  static SizedBox createLogo() {
    return SizedBox(
      width: 64,
      height: 64,
      child: Hero(
        tag: "etg",
        child: Material(
            color: MyAppColors.ACCENT_COLOR,
            borderRadius: BorderRadius.circular(15),
            child: const Icon(
              Icons.auto_graph,
              color: Colors.white,
              size: 45.0,
            )),
      ),
    );
  }
}
