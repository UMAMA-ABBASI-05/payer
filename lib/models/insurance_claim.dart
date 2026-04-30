class InsuranceClaim {
  final int claimId;
  final int mpi;
  final String patientName;
  final double billAmount;
  final String status;

  InsuranceClaim({
    required this.claimId,
    required this.mpi,
    required this.patientName,
    required this.billAmount,
    required this.status,
  });

  factory InsuranceClaim.fromJson(Map<String, dynamic> json) {
    return InsuranceClaim(
      claimId: json['claim_id'],
      mpi: json['mpi'],
      patientName: json['patient_name'] ?? json['name'],
      billAmount: (json['bill_amount'] as num).toDouble(),
      status: json['claim_status'] ?? 'Pending',
    );
  }
}
