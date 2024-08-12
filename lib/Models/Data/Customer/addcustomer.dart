class CustomerModel {
  String? customer_name;
  String? gstin;
  String? company_type;
  String? customer_route;
  String? territory;
  String? gst_category;
  String? sales_person;
  String? email_id;
  String? mobile_no;
  String? customer_group;
  String? address;
  String? pin;
  String? state;
  String? city;
  String? country; 

  CustomerModel(
      {this.customer_name,
      this.gstin,
      this.company_type,
      this.customer_route,
      this.customer_group,
      this.territory,
      this.gst_category,
      this.sales_person,
      this.email_id,
      this.mobile_no,
      this.address,
      this.pin,
      this.city,
      this.state,
      this.country});
  Map<String, dynamic> tomap() {
    return {
      'shop': customer_name,
      'gstin': gstin,
      'customer_route': customer_route,
      'company_type': company_type,
      'customer_group': customer_group,
      'territory': territory,
      'gst_category': gst_category,
      'email_id': email_id,
      'mobile_no': mobile_no,
      'address_line1': address,
      'pincode': pin,
      'state': state,
      'country': country,
      'city': city
    };
  }
}
