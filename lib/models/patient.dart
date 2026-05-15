class Patient {
  final int? pId;
  final int? nic;
  final String name;
  final String phoneNo;
  final String? gender;
  final String? dob;
  final int? policyNumber;

  Patient({
    this.pId,
    this.nic,
    required this.name,
    required this.phoneNo,
    this.gender,
    this.dob,
    this.policyNumber,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      pId: json['p_id'],
      nic: json['nic'],
      name: json['name'],
      phoneNo: json['phone_no'] ?? '',
      gender: json['gender'],
      dob: json['date_of_birth'],
      policyNumber: json['policy_number'],
    );
  }
}
