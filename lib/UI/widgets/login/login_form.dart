import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Utilities/providers/login/loginprovider.dart';

class Widget_LoginForm extends StatefulWidget {
  const Widget_LoginForm({super.key});

  @override
  State<Widget_LoginForm> createState() => _Widget_LoginFormState();
}

class _Widget_LoginFormState extends State<Widget_LoginForm> {
  @override
  Widget build(BuildContext context) {
    var screen_height = MediaQuery.of(context).size.height;
    var theme = Theme.of(context);
    return Container(
      height: screen_height * .3,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          // color: Colors.white,
          // border: Border.all(),
          borderRadius: BorderRadius.circular(8)),
      child: Form(
        child: Consumer<Provider_Login>(builder: (context, login, child) {
          return Column(
            children: [
              Expanded(
                  child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'User Name',
                    hintStyle: theme.textTheme.bodySmall,
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                controller: login.usernameController,
              )),
              Expanded(child:
                  Consumer<Provider_Login>(builder: (context, login, child) {
                return TextFormField(
                  obscureText: login.view_Password,
                  decoration: InputDecoration(
                      suffix: IconButton(
                          onPressed: () {
                            login.setViewPassword();
                          },
                          icon: Icon(
                            login.view_Password
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            color: theme.disabledColor,
                          )),
                      hintText: 'Password',
                      hintStyle: theme.textTheme.bodySmall,
                      prefixIcon: Icon(Icons.key),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  controller: login.passwordController,
                );
              })),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                Size(0, screen_height * .06))),
                        onPressed: () async {
                          await login.loginButtonPressed(context: context);
                        },
                        child: Text(
                          'LOGIN',
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
