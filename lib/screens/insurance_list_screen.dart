import 'package:flutter/material.dart';
import 'add_customer_screen.dart';
import 'pending_claims_screen.dart';
import 'claim_detail_screen.dart' hide PendingClaimsScreen;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hardcoded Data
  final List<Map<String, String>> allPatients = [
    {"id": "1", "name": "Zara", "mpi": "10293", "policy": "Gold - 99283"},
    {
      "id": "2",
      "name": "Ayesha Khan",
      "mpi": "44532",
      "policy": "Silver - 11204",
    },
    {
      "id": "3",
      "name": "Ahmed Ali",
      "mpi": "88723",
      "policy": "Bronze - 55642",
    },
  ];

  List<Map<String, String>> filteredPatients = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredPatients = allPatients;
  }

  void _runFilter(String query) {
    setState(() {
      filteredPatients = allPatients
          .where(
            (user) => user["name"]!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // BARA DARK BLUE HEADER (Exact Figma)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 30,
              left: 25,
              right: 25,
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 248, 248, 248), // Dark Blue
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Insurance List",
                  style: TextStyle(
                    color: Color.fromARGB(255, 30, 19, 90),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      hintText: "Search customer...",
                      prefixIcon: Icon(Icons.search, color: Color(0xFF4C84F3)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST AREA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                var item = filteredPatients[index];
                return GestureDetector(
                  // onTap: () {
                  //   // Click karne par Detail Screen (Zara hardcoded data)
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (c) =>
                  //           ClaimDetailScreen(claimId: int.parse(item['id']!)
                  //           ),
                  //     ),
                  //   );
                  // },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFEDF2FF),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF4C84F3),
                        ),
                      ),
                      title: Text(
                        item['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("MPI: ${item['mpi']}\n${item['policy']}"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // TOTAL 3 NAVIGATION ITEMS (As per your Screenshot)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4C84F3),
        unselectedItemColor: const Color(0xFFC0CCDA),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 28),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded, size: 28),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded, size: 28),
            label: "Pending",
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => AddCustomerScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => PendingClaimsScreen()),
            );
          }
        },
      ),
    );
  }
}
