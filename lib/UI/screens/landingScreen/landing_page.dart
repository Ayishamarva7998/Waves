import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:waves/UI/widgets/Landing/homepage.dart';
import 'package:waves/UI/widgets/Profile/profilepage.dart';
import 'package:waves/Utilities/providers/Home/home.dart';
import 'package:waves/Utilities/providers/landingpage/landing.dart';
import 'package:waves/constants/colors.dart';

class Screen_Landing extends StatefulWidget {
  const Screen_Landing({super.key});

  @override
  State<Screen_Landing> createState() => _Screen_LandingState();
}

class _Screen_LandingState extends State<Screen_Landing> {
  @override
  void initState() {
    Provider_Home().getAttendanceStatus(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Consumer<Provider_Landing>(
          builder: (context, landing, child) {
            return getpages(context: context);
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: theme.colorScheme.secondary,
              hoverColor: theme.colorScheme.tertiary,
              // gap: 8,
              activeColor: theme.colorScheme.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: WaveColors.liteBlue.withOpacity(.2),
              color: Colors.black,
              tabs: [
                GButton(
                  onPressed: () {},
                  icon: CupertinoIcons.home,
                  text: 'Home',
                ),
                // const GButton(
                //   icon: CupertinoIcons.heart,
                //   text: 'Likes',
                // ),
                // const GButton(
                //   icon: CupertinoIcons.search,
                //   text: 'Search',
                // ),
                const GButton(
                  icon: CupertinoIcons.person,
                  text: 'Profile',
                ),
              ],
              // selectedIndex: landing.index,
              onTabChange: (index) {
                // print(index);
                Provider.of<Provider_Landing>(context, listen: false)
                    .setIndex(num: index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getpages({required BuildContext context}) {
    int index = Provider.of<Provider_Landing>(context, listen: false).index;
    print(index);
    switch (index) {
      case 1:
        return Widget_Profile();
      default:
        return Widget_Home();
    }
  }
}
