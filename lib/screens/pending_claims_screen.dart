import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'claim_detail_screen.dart';

class PendingClaimsScreen extends StatelessWidget {
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB), // Subtle grey background like Figma
      appBar: AppBar(
        title: Text("Pending Claims", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: api.getPendingClaims(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var claim = snapshot.data![index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(claim['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("MPI: ${claim['mpi']}", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  //   ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color(0xFF4C84F3),
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  //       padding: EdgeInsets.symmetric(horizontal: 25),
                  //       elevation: 0,
                  //     ),
                  //     onPressed: () => Navigator.push(context, 
                  //     //  MaterialPageRoute(builder: (c) => ClaimDetailScreen(claimId: claim['claim_id']))),
                  //    // child: Text("View", style: TextStyle(color: Colors.white)),
                  //   ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}