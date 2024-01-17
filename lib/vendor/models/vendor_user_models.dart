class VendorUserModel {
  final bool approved;

  final String businessName;

  final String cityValue;

  final String countryValue;

  final String email;

  final String phoneNumber;

  final String stateValue;
  final String storeImage;

  final String vendorId;

  VendorUserModel({
    required this.approved,
    required this.vendorId,
    required this.businessName,
    required this.cityValue,
    required this.countryValue,
    required this.email,
    required this.phoneNumber,
    required this.stateValue,
    required this.storeImage,
  });

  VendorUserModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          vendorId: json['vendorId']! as String,
          businessName: json['businessName']! as String,
          cityValue: json['cityValue']! as String,
          countryValue: json['countryValue']! as String,
          email: json['email']! as String,
          phoneNumber: json['phoneNumber']! as String,
          stateValue: json['stateValue']! as String,
          storeImage: json['storeImage']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'vendorId': vendorId,
      'businessName': businessName,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'email': email,
      'phoneNumber': phoneNumber,
      'stateValue': stateValue,
      'storeImage': storeImage,
    };
  }
}
