import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:waves/Models/Data/Customer/addcustomer.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Location/geolocation.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';

class Provider_addCustomer extends ChangeNotifier {
  String? selected_customer_route;
  String? selected_company_type;
  String? selected_gst_category;
  String? selected_territory;
  String? selected_state;
  String? selected_customerGroup;
  bool isLoading = false;

  List CustomerRoute = [];
  List territory = [];
  List customerGroup = [];
  List state = [];
  List companyType = ['Company', 'Individual', 'Proprietorship', 'Partnership'];

  List gstCategory = [
    'Unregistered',
    'Registered Regular',
  ];
  TextEditingController customerNameController = TextEditingController();
  TextEditingController gstinController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController CountryController =
      TextEditingController(text: 'India');
  TextEditingController pinController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  File? selectedImage;

  

  setLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  // Future selectImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     selectedImage = File(pickedImage.path);
  //   }
  //   notifyListeners();
  // }

  Future addCustomer({
    required BuildContext context,
    required String gstin,
    required String customer_name,
    required String email_id,
    required String mobile_no,
    required File? image,
  }) async {
    setLoading();
    bool isLocationOn = await Geolocator.isLocationServiceEnabled();
    if (!isLocationOn) {
      isLocationOn = await Geolocator.openLocationSettings();
    }
    if (isLocationOn) {
      try {
        await GeoLocation().determinePosition;
        Position location = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // var address = await GeoLocation().GetAddressFromLatLong(
        //     latitude: location.latitude, longitude: location.longitude);

        var result = await Api().addnewCustomer(
            
            context,
            gstin: gstin,
            contactPerson: contactPersonController.text,
            latitude: location.latitude,
            longitude: location.longitude,
            customer_name: customer_name,
            email_id: email_id,
            mobile_no: mobile_no,
            customer_route: selected_customer_route,
            company_type: selected_company_type,
            customer_group: selected_customerGroup,
            gst_category: selected_gst_category,
            territory: selected_territory,
            );

        if (result != null) {
          if (result['success']) {
            
            CustomerModel newCustomer = CustomerModel();
            
            newCustomer.gstin = null;
            newCustomer.customer_name = null;
            newCustomer.email_id = null;
            newCustomer.mobile_no = null;
            newCustomer.company_type = null;
            newCustomer.customer_route = null;
            newCustomer.customer_group = null;
            newCustomer.territory = null;
            newCustomer.gst_category = null;
            // await clearImage();
            gstinController.clear();
            customerNameController.clear();
            contactPersonController.clear();
            upiIdController.clear();
            emailController.clear();
            mobileController.clear();
            addressController.clear();
            pinController.clear();
            cityController.clear();
            CountryController.clear();
            clearDropdownValues(); 
            WavesWidgets()
                .snackBarSuccess(
                    context: context,
                    message: 'created New Customer successfully!');
            Navigator.of(context).pop();
          } else {
           WavesWidgets()
                .snackBarError(context: context, message: result['error']);
          }
        }
      } catch (e) {}
    }
    stopLoading();
  }
  // 32AADCW2196H1ZB

  void clearDropdownValues() {
    gstinController.text = '';
    customerNameController.text = '';
    selected_company_type = null;
    selected_customer_route = null;
    selected_territory = null;
    selected_state = null;
    selected_gst_category = gstCategory[0];
    selected_customerGroup = null;
    notifyListeners();
  }

  Future fetchCustomerRoute(BuildContext context) async {
    var salesPerson = Provider.of<Provider_SalesPerson>(context, listen: false);
    // var primary = Provider.of<Provider_Primary>(context, listen: false);
    var result =
        await Api().getRoutes(context: context);

    if (result != null) {
      if (result['success']) {
        CustomerRoute.clear();
        for (var route in result['message']) {
          CustomerRoute.add(route);
        }
      }
      // if (selected_customer_route != null) {
      //   await primary.getRouteCustomer(context: context);
      // }
    }
    notifyListeners();
  }

  // Future fetchTerritory(BuildContext context) async {
  //   var result = await Api().getTerritory(context);
  //   if (result != null) {
  //     var message = result['message'];
  //     if (message['success']) {
  //       territory.clear();
  //       for (var i in message['Territory']) {
  //         territory.add(i['name']);
  //       }
  //       print({'FINAL : $territory'});
  //     } else {}
  //   }
  //   notifyListeners();
  // }

  // Future fetchCustomerGroup(BuildContext context) async {
  //   var result = await Api().getCustomerGroup(context);
  //   if (result != null) {
  //     var message = result['message'];
  //     if (message['success']) {
  //       customerGroup.clear();
  //       for (var i in message['Customer Group']) {
  //         customerGroup.add(i['name']);
  //       }
  //       print({'FINAL : $customerGroup'});
  //     } else {}
  //   }
  //   notifyListeners();
  // }

  // Future fetchState(BuildContext context) async {
  //   var result = await Api().getState(context);
  //   if (result != null) {
  //     var message = result['message'];
  //     if (message['success']) {
  //       state.clear();
  //       for (var i in message['message']) {
  //         state.add(i);
  //       }
  //       print({'FINAL : $state'});
  //     } else {}
  //   }
  // }
}
