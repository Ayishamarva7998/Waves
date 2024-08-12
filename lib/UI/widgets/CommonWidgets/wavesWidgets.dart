import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waves/constants/colors.dart';

class WavesWidgets {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarSuccess(
      {required BuildContext context, required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: StadiumBorder(),
        duration: Duration(milliseconds: 700),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(166, 76, 175, 79),
        content: Container(
          child: Center(
            child: Text(message),
          ),
        )));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> toastMessage(
      {required BuildContext context,
      required String message,
      int milliseconds = 700,
      Widget icon = const Icon(Icons.warning)}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: StadiumBorder(),
        duration: Duration(milliseconds: milliseconds),
        behavior: SnackBarBehavior.floating,
        backgroundColor: WaveColors.primary.withOpacity(.6),
        content: Container(
          child: Row(
            children: [
              icon,
              Center(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarError(
      {required BuildContext context, required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 700),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromARGB(137, 244, 67, 54),
        content: Container(
          child: Center(child: Text(message)),
        )));
  }

  PreferredSizeWidget commonAppBar(
      {required String text, required BuildContext context}) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios),
      ),
      title: Text("${text}".toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge),
      centerTitle: true,
    );
    //  AppBar(
    //   centerTitle: true,
    //   title: Text(text.toUpperCase()),
    // );
  }

  Widget loadingWidget({required BuildContext context}) {
    var theme = Theme.of(context);
    return Container(
      color: const Color.fromARGB(68, 0, 0, 0),
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: theme.primaryColor,
          size: 100,
        ),
      ),
    );
  }
}
