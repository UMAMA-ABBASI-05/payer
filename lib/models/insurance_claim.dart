class InsuranceClaim {
  final int claimId;
  final int nic;
  final String patientName;
  final double billAmount;
  final String status;

  InsuranceClaim({
    required this.claimId,
    required this.nic,
    required this.patientName,
    required this.billAmount,
    required this.status,
  });

  factory InsuranceClaim.fromJson(Map<String, dynamic> json) {
    return InsuranceClaim(
      claimId: json['claim_id'],
      nic: json['nic'],
      patientName: json['patient_name'] ?? json['name'],
      billAmount: (json['bill_amount'] as num).toDouble(),
      status: json['claim_status'] ?? 'Pending',
    );
  }
}
