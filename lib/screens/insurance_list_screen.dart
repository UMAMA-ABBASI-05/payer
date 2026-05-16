import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_customer_screen.dart';
import 'pending_claims_screen.dart';
import '../services/api_service.dart';
import 'insurance_patient_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _allPatients = [];
  List<dynamic> _filteredPatients = [];
  int _currentIndex = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final insuranceId = prefs.getString('insurance_id') ?? '';
      print('Insurance ID: $insuranceId');

      final data = await ApiService.getAllPatients(insuranceId);
      setState(() {
        _allPatients = data;
        _filteredPatients = data;
        _loading = false;
      });
    } catch (e) {
      print('Load error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  void _runFilter(String query) {
    setState(() {
      _filteredPatients = _allPatients
          .where(
            (p) =>
                (p['name'] ?? '').toLowerCase().contains(query.toLowerCase()),
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
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 30,
              left: 25,
              right: 25,
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 248, 248, 248),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    onChanged: _runFilter,
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

          // List
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4C84F3)),
                  )
                : _filteredPatients.isEmpty
                ? const Center(
                    child: Text(
                      'No patients found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _filteredPatients.length,
                      itemBuilder: (context, index) {
                        final p = _filteredPatients[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InsurancePatientDetailScreen(
                                  pid: p['p_id'],
                                ),
                              ),
                            );
                          },
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
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFEDF2FF),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFF4C84F3),
                                ),
                              ),
                              title: Text(
                                p['name'] ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'NIC: ${p['nic'] ?? 'N/A'}\nPolicy: ${p['policy_number'] ?? 'N/A'}',
                              ),
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
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4C84F3),
        unselectedItemColor: const Color(0xFFC0CCDA),
        showSelectedLabels: true,
        showUnselectedLabels: true,
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
              MaterialPageRoute(builder: (_) => AddCustomerScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PendingClaimsScreen()),
            );
          }
        },
      ),
    );
  }
}
