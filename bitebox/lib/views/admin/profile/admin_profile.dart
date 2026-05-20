import 'package:bitebox/core/routes.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/providers/order_provider.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>();

    final name       = _storage.getStudentName() ?? 'Staff Member';
    final role       = auth.role ?? 'Staff';
    final email      = _storage.getEmail() ?? '—';
    final phone      = _storage.getStudentPhone() ?? '—';
    final location   = _storage.getLocation() ?? '—';
    final restaurant = _storage.getRestaurantName() ?? '—';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: 'Admin Profile'),
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: BBColors.surface2,
            borderRadius: BorderRadius.circular(15),
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
                  child: _storage.getProfilePhoto() != null
                      ? Image.network(
                          _storage.getProfilePhoto()!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Image.asset('assets/images/logo.jpg', fit: BoxFit.cover),
                        )
                      : Image.asset('assets/images/logo.jpg', fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 12),

              // ── Name ──
              Text(
                name.toUpperCase(),
                style: GoogleFonts.koulen(
                  color: Colors.white,
                  fontSize: 32,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              // ── Role badge ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: BBColors.darkRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role.toUpperCase(),
                  style: GoogleFonts.koulen(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Stats row ──
              Row(
                children: [
                  _buildStatCard(
                    label: 'ORDERS',
                    value: '${orders.orders.length}',
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    //phase 6
                    label: 'MENU ITEMS',
                    value: '-',
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    label: 'RATING',
                    value: '4.6',
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
                      style: GoogleFonts.poppins(
                        color: BBColors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(label: 'Email', value: email),
                    _buildDivider(),
                    _buildInfoRow(label: 'Phone', value: phone),
                    _buildDivider(),
                    _buildInfoRow(label: 'Location', value: location),
                    _buildDivider(),
                    _buildInfoRow(label: 'Restaurant', value: restaurant),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Edit Profile button ──
              _buildActionButton(
                label: 'Edit Profile',
                filled: true,
                onPressed: () {
                  Navigator.pushNamed(context, BiteBoxRoutes.adminEditProfile)
                      .then((_) { if (mounted) setState(() {}); });
                },
              ),

              const SizedBox(height: 12),

              // ── Change Password button ──
              _buildActionButton(
                label: 'Change Password',
                filled: false,
                onPressed: () {
                  Navigator.pushNamed(context, BiteBoxRoutes.forgotPassword);
                },
              ),

              const SizedBox(height: 12),

              // ── Log out button ──
              _buildActionButton(
                label: 'Log out',
                filled: false,
                onPressed: () => _showLogoutDialog(context, auth),
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
          border: isRating ? Border.all(color: BBColors.red, width: 1) : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                color: isRating ? BBColors.red : Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
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
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
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
    return Divider(color: Colors.white.withOpacity(0.08), height: 1);
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
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  // ── Logout confirmation dialog ──
  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BBColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // close dialog first
              await auth.logout(); // clears Hive JWT + session
              if (context.mounted) {
                BiteBoxRoutes.logout(context); // navigate to login
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BBColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
