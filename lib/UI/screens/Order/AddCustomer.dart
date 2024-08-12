import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Order/AddCustomer.dart';

class Screen_AddCustomer extends StatelessWidget {
  ValueNotifier<bool> customerNameError = ValueNotifier(false);

  ValueNotifier<bool> addressError = ValueNotifier(false);

  ValueNotifier<bool> cityError = ValueNotifier(false);

  ValueNotifier<bool> pinError = ValueNotifier(false);

  ValueNotifier<bool> countryError = ValueNotifier(false);

  ValueNotifier<bool> gstinError = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("ADD CUSTOMER"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              height: screenHeight,
              width: screenWidth,
              //   // decoration: BoxDecoration(gradient: AppColors().customGradient),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  Consumer<Provider_addCustomer>(
                    builder: (context, primary, child) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          //               // photoSelector(context),
                          //               // const SizedBox(
                          //               //   height: 5,
                          //               // ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                              valueListenable: gstinError,
                              builder: (context, value, child) => TextField(
                                controller: primary.gstinController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    labelText: 'GSTIN/UIN',
                                    errorText: value
                                        ? 'Enter a valid GSTIN/UIN'
                                        : null,
                                    prefixIcon: Icon(
                                      Icons.file_copy_outlined,
                                      // color: AppColors().textButton,
                                    )),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                onChanged: (value) {
                                  gstinError.value = value.length < 15;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                              valueListenable: customerNameError,
                              builder: (context, nameError, child) => TextField(
                                controller: primary.customerNameController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    errorText: nameError
                                        ? 'Enter Contact Number'
                                        : null,
                                    labelText: 'Customer Name',
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      // color: AppColors().textButton,
                                    )),
                                onChanged: (value) {
                                  customerNameError.value = value.isEmpty;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                              valueListenable: customerNameError,
                              builder: (context, nameError, child) => TextField(
                                controller: primary.contactPersonController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    errorText: nameError
                                        ? 'Enter Contact Person'
                                        : null,
                                    labelText: 'Contact Person',
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      // color: AppColors().textButton,
                                    )),
                                onChanged: (value) {
                                  customerNameError.value = value.isEmpty;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                              valueListenable: customerNameError,
                              builder: (context, nameError, child) => TextField(
                                controller: primary.upiIdController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    errorText: nameError
                                        ? 'Enter Contact Number'
                                        : null,
                                    labelText: 'Upi Id',
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      // color: AppColors().textButton,
                                    )),
                                onChanged: (value) {
                                  customerNameError.value = value.isEmpty;
                                },
                              ),
                            ),
                          ),
                          //               // Padding(
                          //               //   padding: const EdgeInsets.all(6),
                          //               //   child: Container(
                          //               //     padding: const EdgeInsets.all(3),
                          //               //     height: 40,
                          //               //     decoration: BoxDecoration(
                          //               //         border: Border.all(color: Colors.grey),
                          //               //         color: Colors.white,
                          //               //         borderRadius: BorderRadius.circular(10),
                          //               //         boxShadow: [
                          //               //           BoxShadow(
                          //               //               offset: const Offset(1, 1),
                          //               //               color: const Color(0xFF000000)
                          //               //                   .withOpacity(0.2),
                          //               //               blurRadius: 1,
                          //               //               spreadRadius: 1),
                          //               //         ]),
                          //               //     child: Consumer<Provider_addCustomer>(
                          //               //       builder: (context, primary, child) =>
                          //               //           DropdownButton(
                          //               //         underline: Container(),
                          //               //         hint:
                          //               //             const Center(child: Text("Company Type")),
                          //               //         isExpanded: true,
                          //               //         items: primary.companyType
                          //               //             .map(
                          //               //               (e) => DropdownMenuItem(
                          //               //                 value: e,
                          //               //                 child: Center(
                          //               //                   child: Text(
                          //               //                     '$e'.toUpperCase(),
                          //               //                     // style: TextStyle(
                          //               //                     //     color: AppColors().dropDown),
                          //               //                   ),
                          //               //                 ),
                          //               //               ),
                          //               //             )
                          //               //             .toList(),
                          //               //         onChanged: (value) async {
                          //               //           primary.selected_company_type =
                          //               //               value.toString();
                          //               //           primary.notifyListeners();
                          //               //         },
                          //               //         value: primary.selected_company_type,
                          //               //       ),
                          //               //     ),
                          //               //   ),
                          //               // ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(1, 1),
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.2),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Consumer<Provider_addCustomer>(
                                builder: (context, primary, child) =>
                                    DropdownButton(
                                  underline: Container(),
                                  hint: const Center(
                                      child: Text("Customer Group")),
                                  isExpanded: true,
                                  items: primary.customerGroup
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Center(
                                            child: Text(
                                              '$e'.toUpperCase(),
                                              // style: TextStyle(
                                              //     color: AppColors().dropDown),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) async {
                                    primary.selected_customerGroup =
                                        value.toString();
                                    primary.notifyListeners();
                                  },
                                  value: primary.selected_customerGroup,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(1, 1),
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.2),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Consumer<Provider_addCustomer>(
                                builder: (context, primary, child) =>
                                    DropdownButton(
                                  underline: Container(),
                                  hint: const Center(child: Text("Route")),
                                  isExpanded: true,
                                  items: primary.CustomerRoute.map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Center(
                                        child: Text(
                                          '$e'.toUpperCase(),
                                          // style: TextStyle(
                                          //     color: AppColors().dropDown),
                                        ),
                                      ),
                                    ),
                                  ).toList(),
                                  onChanged: (value) async {
                                    primary.selected_customer_route =
                                        value.toString();
                                    primary.notifyListeners();
                                  },
                                  value: primary.selected_customer_route,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(1, 1),
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.2),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Consumer<Provider_addCustomer>(
                                builder: (context, primary, child) =>
                                    DropdownButton(
                                  underline: Container(),
                                  hint: const Center(child: Text("Territory")),
                                  isExpanded: true,
                                  items: primary.territory
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Center(
                                            child: Text(
                                              '$e'.toUpperCase(),
                                              // style: TextStyle(
                                              //     color: AppColors().dropDown),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) async {
                                    primary.selected_territory =
                                        value.toString();
                                    primary.notifyListeners();
                                  },
                                  value: primary.selected_territory,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(1, 1),
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.2),
                                        blurRadius: 1,
                                        spreadRadius: 1),
                                  ]),
                              child: Consumer<Provider_addCustomer>(
                                builder: (context, primary, child) =>
                                    DropdownButton(
                                  underline: Container(),
                                  hint:
                                      const Center(child: Text("GST Category")),
                                  isExpanded: true,
                                  items: primary.gstCategory
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Center(
                                            child: Text(
                                              '$e'.toUpperCase(),
                                              // style: TextStyle(
                                              //     color: AppColors().dropDown),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) async {
                                    primary.selected_gst_category =
                                        value.toString();
                                    primary.notifyListeners();
                                  },
                                  value: primary.selected_gst_category,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          const Text(
                            "Primary Contact details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                //  color: AppColors().heading,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: primary.emailController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  labelText: 'Email ID',
                                  prefixIcon: Icon(
                                    Icons.mail_outline_outlined,
                                    // color: AppColors().textButton,
                                  )),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: primary.mobileController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  labelText: 'Mobile Number',
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    // color: AppColors().textButton,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Consumer<Provider_addCustomer>(
                    builder: (context, primary, child) => Container(
                        child: Column(children: [
                      Center(
                        child: Text(
                          "Primary Address Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder(
                          valueListenable: addressError,
                          builder: (context, nameError, child) => TextField(
                            controller: primary.addressController,
                            decoration: InputDecoration(
                                errorText: nameError ? 'Enter Address' : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                labelText: 'Address',
                                prefixIcon: Icon(
                                  Icons.add_home_outlined,
                                )),
                            onChanged: (value) {
                              addressError.value = value.isEmpty;
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ValueListenableBuilder(
                                valueListenable: pinError,
                                builder: (context, nameError, child) =>
                                    TextField(
                                  keyboardType: TextInputType.number,
                                  controller: primary.pinController,
                                  decoration: InputDecoration(
                                      errorText:
                                          nameError ? 'Enter pin code' : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      labelText: 'Postal Code',
                                      prefixIcon: Icon(
                                        Icons.pin_outlined,
                                      )),
                                  onChanged: (value) {
                                    pinError.value = value.isEmpty;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 196,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ValueListenableBuilder(
                                valueListenable: cityError,
                                builder: (context, nameError, child) =>
                                    TextField(
                                  controller: primary.cityController,
                                  decoration: InputDecoration(
                                      errorText:
                                          nameError ? 'Enter city/town' : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      labelText: 'City/Town',
                                      prefixIcon: Icon(
                                        Icons.location_city_sharp,
                                      )),
                                  onChanged: (value) {
                                    cityError.value = value.isEmpty;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(3),
                            width: 180,
                            // height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(1, 1),
                                  color:
                                      const Color(0xFF000000).withOpacity(0.2),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Consumer<Provider_addCustomer>(
                              builder: (context, primary, child) =>
                                  DropdownButton(
                                underline: Container(),
                                hint: const Center(child: Text("Select State")),
                                isExpanded: true,
                                items: primary.state
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Center(
                                          child: Text(
                                            '$e'.toUpperCase(),
                                            // style: TextStyle(
                                            //     color: AppColors().dropDown),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) async {
                                  primary.selected_state = value.toString();
                                  primary.notifyListeners();
                                },
                                value: primary.selected_state,
                              ),
                            ),
                          ),
                          Container(
                            width: 196,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ValueListenableBuilder(
                                valueListenable: countryError,
                                builder: (context, nameError, child) =>
                                    TextField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: primary.CountryController,
                                  decoration: InputDecoration(
                                      errorText:
                                          nameError ? 'Enter country' : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      labelText: 'Country',
                                      prefixIcon: Icon(
                                        Icons.location_city,
                                      )),
                                  onChanged: (value) {
                                    countryError.value = value.isEmpty;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
                  ),
                  Consumer<Provider_addCustomer>(
                    builder: (context, primary, child) => ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // customerNameError.value =
                            //     primary.customerNameController.text.isEmpty;
                            // addressError.value =
                            //     primary.addressController.text.isEmpty;
                            // pinError.value = primary.pinController.text.isEmpty;
                            // cityError.value =
                            //     primary.cityController.text.isEmpty;

                            // countryError.value =
                            //     primary.CountryController.text.isEmpty;
                            // if (primary.selected_customerGroup == null ||
                            //     primary.selected_customer_route == null ||
                            //     primary.selected_territory == null ||
                            //     primary.selected_gst_category == null ||
                            //     primary.selected_state == null) {
                            //   WavesWidgets().snackBarError(
                            //       context: context,
                            //       message:
                            //           '! please select items from dropdown');
                            // }

                            // if (!customerNameError.value &&
                            //     !addressError.value &&
                            //     !pinError.value &&
                            //     !cityError.value &&
                            //     !countryError.value &&
                            //     primary.selected_customerGroup != null &&
                            //     primary.selected_customer_route != null &&
                            //     primary.selected_territory != null &&
                            //     primary.selected_gst_category != null &&
                            //     primary.selected_state != null) {
                            //   var providerAddCustomer =
                            //       Provider.of<Provider_addCustomer>(context,
                            //           listen: false);

                            //   await Provider.of<Provider_addCustomer>(context,
                            //           listen: false)
                            //       .addCustomer(
                            //           context: context,
                            //           gstin: primary.gstinController.text,
                            //           customer_name:
                            //               primary.customerNameController.text,
                            //           email_id: primary.emailController.text,
                            //           mobile_no: primary.mobileController.text,
                            //           image: providerAddCustomer.selectedImage);
                            // }
                          },
                          child: const Text("ADD CUSTOMER"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<Provider_addCustomer>(builder: (context, customer, child) {
            return Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: customer.isLoading
                    ? Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(80, 0, 0, 0)),
                        child: Center(
                          child: Container(
                              height: 100,
                              width: 100,
                              child: WavesWidgets()
                                  .loadingWidget(context: context)),
                        ),
                      )
                    : const Padding(padding: EdgeInsets.zero));
          }),
        ],
      ),
    );
  }

  // Widget photoSelector(BuildContext context) {
  //   return Consumer<Provider_addCustomer>(
  //     builder: (context, value, child) => Container(
  //       width: 80,
  //       height: 80,
  //       decoration: BoxDecoration(
  //         color: Colors.grey,
  //         borderRadius: BorderRadius.circular(80),
  //       ),
  //       child: Stack(
  //         children: [
  //           value.selectedImage != null
  //               ? Align(
  //                   alignment: Alignment.center,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(80),
  //                     child: Image.file(
  //                       value.selectedImage!,
  //                       width: 80,
  //                       height: 80,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 )
  //               : const Align(
  //                   alignment: Alignment.center,
  //                   child: Icon(Icons.person, color: Colors.white, size: 50),
  //                 ),
  //           // GestureDetector(
  //           //   onTap: () {
  //           //     Provider.of<Provider_addCustomer>(context, listen: false)
  //           //         .selectImage();
  //           //   },
  //           //   child: Align(
  //           //     alignment: Alignment.bottomRight,
  //           //     child: Container(
  //           //       width: 30,
  //           //       height: 30,
  //           //       decoration: BoxDecoration(
  //           //         color: Colors.black,
  //           //         borderRadius: BorderRadius.circular(15),
  //           //       ),
  //           //       child: const Icon(Icons.add, color: Colors.white, size: 20),
  //           //     ),
  //           //   ),
  //           // ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
