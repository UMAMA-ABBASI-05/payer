import 'package:flutter/material.dart';
import 'claim_detail_screen.dart';

class PendingClaimsScreen extends StatelessWidget {
  // Exact Figma style hardcoded data
  final List<Map<String, dynamic>> dummyClaims = [
    {"id": 1, "name": "Zara", "mpi": "10293", "status": "Pending"},
    {"id": 2, "name": "Ayesha Khan", "mpi": "44532", "status": "Pending"},
    {"id": 3, "name": "Ahmed Ali", "mpi": "88723", "status": "Pending"},
    {"id": 4, "name": "Hamza Sheikh", "mpi": "22109", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Figma grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pending Claims",
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: dummyClaims.length,
        itemBuilder: (context, index) {
          var claim = dummyClaims[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text Side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      claim['name'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "MPI: ${claim['mpi']}",
                      style: const TextStyle(color: Color(0xFF6B778C), fontSize: 14),
                    ),
                  ],
                ),
                
                // Figma Blue "View" Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C84F3), // Exact Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Zara ya kisi bhi card pe click karne se detail khulegi
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (c) => ClaimDetailScreen(claimId: claim['id']),
                    //   ),
                    // );
                  },
                  child: const Text(
                    "View",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ClaimDetailScreen {
}