import 'package:bitebox/views/admin/profile/editprofile.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // ── Hardcoded data for now (replace with your Hive/backend model later) ──
  final String _name           = 'Abdullah Khan';
  final String _role           = 'Restaurant Admin';
  final String _email          = 'john@restaurant.com';
  final String _phone          = '+92 300 1234567';
  final String _location       = 'Karachi, Pakistan';
  final String _restaurant     = 'The Grand Table';
  final int    _totalOrders    = 220;
  final int    _totalMenuItems = 20;
  final double _rating         = 4.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BBColors.darkRed,
        toolbarHeight: 74,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 74,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PROFILE',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
             color: BBColors.surface2,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            children: [
          
              const SizedBox(height: 10),
          
              // ── Avatar ──
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: BBColors.red, width: 3),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.jpg', // replace with actual profile pic
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          
              const SizedBox(height: 12),
          
              // ── Name ──
              Text(
                _name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  letterSpacing: 1.2,
                ),
              ),
          
              const SizedBox(height: 8),
          
              // ── Role badge ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: BBColors.darkRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _role.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
          
              // ── Stats row ──
              Row(
                children: [
                  _buildStatCard(label: 'ORDERS',     value: '$_totalOrders'),
                  const SizedBox(width: 10),
                  _buildStatCard(label: 'MENU ITEMS', value: '$_totalMenuItems'),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    label: 'RATING',
                    value: _rating.toString(),
                    isRating: true,
                  ),
                ],
              ),
          
              const SizedBox(height: 20),
          
              // ── Profile info card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: TextStyle(
                        color: BBColors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(label: 'Email',      value: _email),
                    _buildDivider(),
                    _buildInfoRow(label: 'Phone',      value: _phone),
                    _buildDivider(),
                    _buildInfoRow(label: 'Location',   value: _location),
                    _buildDivider(),
                    _buildInfoRow(label: 'Restaurant', value: _restaurant),
                  ],
                ),
              ),
          
              const SizedBox(height: 24),
          
              // ── Edit Profile button ──
              _buildActionButton(
                label: 'Edit Profile',
                filled: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Editprofile()),
                  );
                },
              ),
          
              const SizedBox(height: 12),
          
              // ── Change Password button ──
              _buildActionButton(
                label: 'Change Password',
                filled: false,
                onPressed: () {
                  // TODO: Navigate to change password screen
                },
              ),
          
              const SizedBox(height: 12),
          
              // ── Log out button ──
              _buildActionButton(
                label: 'Log out',
                filled: false,
                onPressed: () => _showLogoutDialog(),
              ),
          
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stat card widget ──
  Widget _buildStatCard({
    required String label,
    required String value,
    bool isRating = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isRating ? const Color(0xFF2A1A1A) : BBColors.border,
          borderRadius: BorderRadius.circular(12),
          border: isRating
              ? Border.all(color: BBColors.red, width: 1)
              : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: isRating ? BBColors.red : Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Info row widget ──
  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Divider ──
  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.08),
      height: 1,
    );
  }

  // ── Action button ──
  Widget _buildActionButton({
    required String label,
    required bool filled,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: BBColors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: BBColors.red,
                side: BorderSide(color: BBColors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  // ── Logout confirmation dialog ──
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Clear session and navigate to login
              // Navigator.pushAndRemoveUntil(context, ...)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BBColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}