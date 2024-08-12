import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Location/locationServices.dart';
import 'package:waves/UI/screens/landingScreen/landing_page.dart';
import 'package:waves/UI/screens/loginScreen/loginsreen.dart';
import 'package:waves/Utilities/providers/Home/home.dart';
import 'package:waves/Utilities/providers/Invoice/invoiceprovider.dart';
import 'package:waves/Utilities/providers/Leave/leave.dart';
import 'package:waves/Utilities/providers/Order/AddCustomer.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/Order/history.dart';
import 'package:waves/Utilities/providers/Order/payment.dart';
import 'package:waves/Utilities/providers/Printer/printer_provider.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';
import 'package:waves/Utilities/providers/landingpage/landing.dart';
import 'package:waves/Utilities/providers/login/loginprovider.dart';
import 'package:waves/constants/colors.dart';
import 'package:waves/main.dart';

class WavesApp extends StatelessWidget {
  const WavesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Provider_Login>(
            create: (context) => Provider_Login()),
        ChangeNotifierProvider<Provider_Landing>(
            create: (context) => Provider_Landing()),
        ChangeNotifierProvider<Provider_SalesPerson>(
            create: (context) => Provider_SalesPerson()),
        ChangeNotifierProvider<Provider_Home>(
            create: (context) => Provider_Home()),
        ChangeNotifierProvider<Provider_Primary>(
            create: (context) => Provider_Primary()),
        ChangeNotifierProvider<Provider_Item>(
            create: (context) => Provider_Item()),
        ChangeNotifierProvider<Provider_Payment>(
            create: (context) => Provider_Payment()),
        ChangeNotifierProvider<Provider_History>(
            create: (context) => Provider_History()),
        ChangeNotifierProvider<Provider_Leave>(
            create: (context) => Provider_Leave()),
        ChangeNotifierProvider<Provider_addCustomer>(
            create: (context) => Provider_addCustomer()),
        ChangeNotifierProvider<LocationServices>(
            create: (context) => LocationServices()),
        ChangeNotifierProvider<Provider_Invoice>(
            create: (context) => Provider_Invoice()),
            ChangeNotifierProvider(create: (context) => BluetoothProvider(),)
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: WaveColors.primary),
            textTheme: TextTheme(
              bodyLarge: GoogleFonts.notoSansJavanese(
                  color: Color.fromARGB(255, 2, 56, 110)),
              bodyMedium: GoogleFonts.notoSansJavanese(
                  color: Color.fromARGB(255, 2, 56, 110)),
              bodySmall: GoogleFonts.notoSansJavanese(
                  color: Color.fromARGB(255, 2, 56, 110)),
              headlineMedium:
                  GoogleFonts.notoSansJavanese(color: WaveColors.vilot),
            ),
            iconTheme: IconThemeData(color: WaveColors.primary),
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.rgb(172, 226, 225)
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(
                seedColor: WaveColors.primary,
                primary: WaveColors.primary,
                secondary: WaveColors.secondary,
                tertiary: WaveColors.tertiory),
            useMaterial3: true,
          ),
          home: loginStatus ? const Screen_Landing() : const Screen_Login()
          // const Screen_Login(),
          ),
    );
  }
}
