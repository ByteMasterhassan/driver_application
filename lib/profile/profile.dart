import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lower_bar/lower_bar.dart';
import '../profile/profile_service/profile_service.dart';
import '../dashboard_screen/dashboard_components/sidebar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<int?> _getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('driverId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Sidebar(),
      body: FutureBuilder<int?>(
        future: _getDriverId(),
        builder: (context, idSnapshot) {
          if (idSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
            );
          }

          if (idSnapshot.hasError || idSnapshot.data == null) {
            return const Center(
              child: Text(
                'Unable to load driver ID',
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          }

          return FutureBuilder(
            future: ProfileService.getLoggedInDriverProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'No profile found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final profile = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildProfileHeader(profile),
                    const SizedBox(height: 32),
                    _buildProfileDetails(profile),
                    const SizedBox(height: 32),
                    _buildCompanyInfo(),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const LowerBar(),
    );
  }

  Widget _buildProfileHeader(DriverProfile profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: profile.profilePicture != null &&
                  profile.profilePicture!.isNotEmpty
              ? NetworkImage(
                  profile.profilePicture!.startsWith('http')
                      ? profile.profilePicture!
                      : 'http://10.0.2.2:5000${profile.profilePicture!}',
                )
              : const AssetImage('')
                  as ImageProvider,
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profile.username,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFD4AF37),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails(DriverProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailItem(Icons.email, profile.email),
            const Divider(color: Colors.grey),
            _buildDetailItem(Icons.calendar_today,
                profile.dateOfBirth ?? 'N/A'),
            const Divider(color: Colors.grey),
            _buildDetailItem(
              Icons.verified,
              profile.isApproved ? 'Approved Driver' : 'Pending Approval',
            ),
            const Divider(color: Colors.grey),
            _buildDetailItem(Icons.badge, 'ID: ${profile.id}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37), width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.business, color: Color(0xFFD4AF37), size: 40),
            SizedBox(width: 16),
            Text(
              'Hyper Atlantic Transport',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
