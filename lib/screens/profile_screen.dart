import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser; // Firebase user (uid/email/displayName etc.)

    final name = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : 'Guest User';
    final email = user?.email ?? 'Not logged in';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _ProfileHeader(
            name: name,
            email: email,
            // avatarUrl: user?.photoURL,
          ),
          const SizedBox(height: 16),

          _StatsRow(
            items: const [
              _StatItem(label: 'Orders', value: '—'),
              _StatItem(label: 'Cart', value: '—'),
              _StatItem(label: 'Wishlist', value: '—'),
            ],
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: 'Account',
            children: [
              _Tile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Name, photo, personal info',
                onTap: () {
                  // TODO: Navigate to edit profile screen
                },
              ),
              _Tile(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',
                subtitle: 'Manage your shipping address',
                onTap: () {
                  // TODO: Navigate to address screen
                },
              ),
              _Tile(
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                subtitle: 'Password, security settings',
                onTap: () {
                  // TODO
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: 'Support',
            children: [
              _Tile(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'FAQs and support',
                onTap: () {},
              ),
              _Tile(
                icon: Icons.receipt_long_outlined,
                title: 'Terms & Policies',
                subtitle: 'Read our policies',
                onTap: () {},
              ),
              _Tile(
                icon: Icons.star_outline,
                title: 'Rate Smart Shop',
                subtitle: 'Tell us what you think',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sign out / Login button
          if (user != null)
            _DangerButton(
              text: 'Sign Out',
              onTap: () async {
                // যদি AuthProvider এ signOut থাকে
                await auth.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out')),
                  );
                }
              },
            )
          else
            _PrimaryButton(
              text: 'Login / Sign Up',
              onTap: () {
                // TODO: Navigate to login screen
              },
            ),
        ],
      ),
    );
  }
}

// ---------------- Widgets ----------------

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;

  const _ProfileHeader({
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                ? NetworkImage(avatarUrl!)
                : null,
            child: (avatarUrl == null || avatarUrl!.isEmpty)
                ? const Icon(Icons.person, size: 30, color: Colors.black54)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Smart Shop',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<_StatItem> items;
  const _StatsRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((e) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: e == items.last ? 0 : 10),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  e.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e.label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _DangerButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red.shade700,
        side: BorderSide(color: Colors.red.shade200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
