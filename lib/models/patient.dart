class Patient {
  final int? pId;
  final int? mpi;
  final String name;
  final String phoneNo;
  final String? gender;
  final String? dob;
  final int? policyNumber;

  Patient({
    this.pId,
    this.mpi,
    required this.name,
    required this.phoneNo,
    this.gender,
    this.dob,
    this.policyNumber,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      pId: json['p_id'],
      mpi: json['mpi'],
      name: json['name'],
      phoneNo: json['phone_no'] ?? '',
      gender: json['gender'],
      dob: json['date_of_birth'],
      policyNumber: json['policy_number'],
    );
  }
}
