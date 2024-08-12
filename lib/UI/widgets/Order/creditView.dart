import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/constants/colors.dart';

class Widget_CreditView extends StatelessWidget {
  const Widget_CreditView({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Provider_Primary>(context, listen: false)
        .getCustomerCredits(context: context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = screenHeight * .25;
    var theme = Theme.of(context);
    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(colors: [
            theme.colorScheme.primary.withOpacity(.5),
            Color.fromARGB(255, 120, 117, 231)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Stack(
        children: [
          Positioned(
              top: containerHeight * .35,
              right: screenWidth * .7,
              bottom: containerHeight * .4,
              left: screenWidth * .03,
              child: const Image(
                image: AssetImage('assets/images/chip.png'),
                height: 50,
                width: 20,
              )),
          Positioned(
              top: containerHeight * .1,
              right: screenWidth * .02,
              bottom: containerHeight * .8,
              left: screenWidth * .05,
              child: Text(
                'Credits',
                style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.background,
                    fontWeight: FontWeight.bold),
              )),
          Positioned(
              top: containerHeight * .2,
              right: screenWidth * .01,
              bottom: containerHeight * .65,
              left: screenWidth * .45,
              child: Container(
                // color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Limit',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ':',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Consumer<Provider_Primary>(
                          builder: (context, primary, child) {
                        return Text(
                          '${primary.creditLimit}',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.background,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                    ),
                  ],
                ),
              )),
          Positioned(
              top: containerHeight * .35,
              right: screenWidth * .01,
              bottom: containerHeight * .5,
              left: screenWidth * .45,
              child: Container(
                // color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Used',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ':',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Consumer<Provider_Primary>(
                          builder: (context, primary, child) {
                        return Text(
                          '${primary.outstandingAmount}',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.background,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                    ),
                  ],
                ),
              )),
          Positioned(
              top: containerHeight * .5,
              right: screenWidth * .01,
              bottom: containerHeight * .4,
              left: screenWidth * .45,
              child: Container(
                // color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Balance',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ':',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Consumer<Provider_Primary>(
                          builder: (context, primary, child) {
                        return Text(
                          '${primary.creditBalance}',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.background,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
