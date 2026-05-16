class StudentModel {
  final String cmsid;
  final String name;
  final String phone;
  final String category;
  final String paymentMethod; //cash or online method

  StudentModel({
    required this.cmsid,
    required this.name,
    required this.phone,
    required this.category,
    required this.paymentMethod,
  });

  factory StudentModel.fromJson(Map<String,dynamic> json)=>StudentModel(
        cmsid:         json['cms_id'] as String,
        name:          json['name'] as String,
        phone:         json['phone'] as String,
        category:      json['category'] as String,
        paymentMethod: json['payment_method'] as String? ?? 'cash',
  );

  get restaurantName => null;

  get email => null;

  get location => null;

  get bio => null;

  Map<String,dynamic> toJson()=>{
    'cms_id':cmsid,
    'name':name,
    'phone':phone,
    'category':category,
    'paymentMethod':paymentMethod
  };
}
