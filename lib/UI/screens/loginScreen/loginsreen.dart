import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:waves/UI/widgets/login/login_form.dart';
import 'package:waves/Utilities/providers/login/loginprovider.dart';
import 'package:waves/constants/colors.dart';

class Screen_Login extends StatelessWidget {
  const Screen_Login({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [theme.colorScheme.primary, WaveColors.vilot])),
                child: ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    children: [
                      Container(
                        height: screenHeight * .3,
                        padding: EdgeInsetsDirectional.symmetric(
                            vertical: screenHeight * .1),
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          padding: EdgeInsetsDirectional.symmetric(
                              vertical: screenHeight * .03),
                          child: const Image(
                              image: AssetImage('assets/images/user.png')),
                        ),
                      ),
                      Container(
                        child: const Widget_LoginForm(),
                      )
                    ]),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Consumer<Provider_Login>(
                builder: (context, report, child) {
                  return report.isLoading
                      ? Container(
                          color: const Color.fromARGB(68, 0, 0, 0),
                          child: Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: theme.primaryColor,
                              size: 100,
                            ),
                          ),
                        )
                      : const Padding(padding: EdgeInsets.zero);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
