import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../widgets/profile_section.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: BlocProvider(
        create: (context) => sl<AuthCubit>()..checkAuthStatus(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AuthCubit>().checkAuthStatus(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is Authenticated) {
              return ProfileContent(user: state.user);
            } else {
              return const Center(
                child: Text(
                  'Not authenticated',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final dynamic user;

  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2A2A2A),
                    border: Border.all(
                      color: const Color(0xFF2196F3),
                      width: 3,
                    ),
                  ),
                  child:
                      user.profileImageUrl != null &&
                          user.profileImageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            user.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              );
                            },
                          ),
                        )
                      : const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name ?? 'User',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                ),
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      user.bio!,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Account Section
          ProfileSection(
            title: 'Account',
            children: [
              ProfileItem(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () {
                  // TODO: Navigate to edit profile screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile coming soon')),
                  );
                },
              ),
              ProfileItem(
                icon: Icons.email_outlined,
                title: 'Email: ${user.email ?? "N/A"}',
                trailing: user.isEmailVerified
                    ? const Icon(Icons.verified, color: Colors.green, size: 20)
                    : null,
                onTap: null,
              ),
              ProfileItem(
                icon: Icons.calendar_today_outlined,
                title: 'Joined: ${_formatDate(user.createdAt)}',
                onTap: null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Interests Section
          if (user.interests != null && user.interests.isNotEmpty)
            ProfileSection(
              title: 'Interests',
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.interests
                      .map<Widget>(
                        (interest) => Chip(
                          label: Text(interest),
                          backgroundColor: const Color(0xFF2A2A2A),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Settings Section
          ProfileSection(
            title: 'Settings',
            children: [
              ProfileItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications settings coming soon'),
                    ),
                  );
                },
              ),
              ProfileItem(
                icon: Icons.bookmark_outline,
                title: 'Bookmarked Articles',
                onTap: () {
                  // TODO: Navigate to bookmarked articles
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bookmarked articles coming soon'),
                    ),
                  );
                },
              ),
              ProfileItem(
                icon: Icons.palette_outlined,
                title: 'Theme',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Theme settings coming soon')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Account Actions
          ProfileSection(
            title: 'Account Actions',
            children: [
              ProfileItem(
                icon: Icons.logout_outlined,
                title: 'Sign Out',
                iconColor: Colors.red,
                titleColor: Colors.red,
                onTap: () {
                  _showLogoutDialog(context, authCubit);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context, AuthCubit authCubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              authCubit.signOut();
              Navigator.pop(context);
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
