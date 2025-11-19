import 'package:customer_booking/core/presentation/cubits/user_profile_cubit.dart';
import 'package:customer_booking/core/presentation/cubits/user_profile_state.dart';
import 'package:customer_booking/features/credits/presentation/screens/purchase_credits_screen.dart';
import 'package:customer_booking/features/bookings/booking_injection.dart';
import 'package:customer_booking/core/services/api/dio_consumer.dart';
import 'package:customer_booking/core/services/auth_storage_service.dart';
import 'package:customer_booking/core/routers/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileCubit>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state.status == UserProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == UserProfileStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserProfileCubit>().loadProfile();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profile = state.profile;
          if (profile == null) {
            return const Center(child: Text('No profile data'));
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Profile Header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Colors.blue,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[700]!, Colors.blue[500]!],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child:
                                profile.avatarUrl != null &&
                                    profile.avatarUrl!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      profile.avatarUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return _buildDefaultAvatar(
                                              profile.name,
                                            );
                                          },
                                    ),
                                  )
                                : _buildDefaultAvatar(profile.name),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Credits Card
                      _buildCreditsCard(context, profile.credits),
                      const SizedBox(height: 16),

                      // Account Information
                      _buildSectionTitle('Account Information'),
                      const SizedBox(height: 8),
                      _buildInfoCard(context, [
                        _InfoItem(
                          icon: Icons.person_outline,
                          label: 'Full Name',
                          value: profile.name,
                        ),
                        _InfoItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: profile.email,
                        ),
                        if (profile.phone != null && profile.phone!.isNotEmpty)
                          _InfoItem(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: profile.phone!,
                          ),
                        _InfoItem(
                          icon: Icons.badge_outlined,
                          label: 'Account Type',
                          value: profile.role.toUpperCase(),
                        ),
                      ]),
                      const SizedBox(height: 16),

                      // Quick Actions
                      _buildSectionTitle('Quick Actions'),
                      const SizedBox(height: 8),
                      _buildQuickActions(context),
                      const SizedBox(height: 24),

                      // Logout Button
                      _buildLogoutButton(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Text(
      name.isNotEmpty ? name[0].toUpperCase() : 'U',
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildCreditsCard(BuildContext context, int credits) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[700]!, Colors.amber[500]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final apiConsumer = DioConsumer(dio: Dio());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<UserProfileCubit>()),
                    BlocProvider(
                      create: (_) =>
                          BookingInjection.getCreditsCubit(apiConsumer),
                    ),
                  ],
                  child: const PurchaseCreditsScreen(),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.stars, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Credits',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$credits',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<_InfoItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          items.length,
          (index) => Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(items[index].icon, color: Colors.blue),
                ),
                title: Text(
                  items[index].label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                subtitle: Text(
                  items[index].value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (index < items.length - 1)
                Divider(height: 1, indent: 72, color: Colors.grey[200]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.add_card,
            title: 'Purchase Credits',
            subtitle: 'Buy more credits for bookings',
            onTap: () {
              final apiConsumer = DioConsumer(dio: Dio());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<UserProfileCubit>(),
                      ),
                      BlocProvider(
                        create: (_) =>
                            BookingInjection.getCreditsCubit(apiConsumer),
                      ),
                    ],
                    child: const PurchaseCreditsScreen(),
                  ),
                ),
              );
            },
          ),
          Divider(height: 1, color: Colors.grey[200]),
          _buildActionTile(
            icon: Icons.history,
            title: 'Transaction History',
            subtitle: 'View your credit transactions',
            onTap: () {
              // TODO: Implement transaction history
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
            },
          ),
          Divider(height: 1, color: Colors.grey[200]),
          _buildActionTile(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            subtitle: 'Update your information',
            onTap: () {
              // TODO: Implement edit profile
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          // Show confirmation dialog
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );

          if (confirmed == true && context.mounted) {
            await AuthStorageService.clearToken();
            if (context.mounted) {
              context.go(AppRouters.loginRoute);
            }
          }
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem({required this.icon, required this.label, required this.value});
}
