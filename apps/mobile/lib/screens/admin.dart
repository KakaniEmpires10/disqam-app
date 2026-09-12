import 'package:flutter/material.dart';

import '../services/admin_api.dart';
import '../services/admin_store.dart';
import '../widgets/common.dart';
import 'admin_analytics.dart';
import 'admin_dashboard.dart';
import 'admin_diary.dart';
import 'admin_participants.dart';

class AdminEntryPage extends StatefulWidget {
  const AdminEntryPage({super.key, this.store});

  final AdminStore? store;

  @override
  State<AdminEntryPage> createState() => _AdminEntryPageState();
}

class _AdminEntryPageState extends State<AdminEntryPage> {
  late final AdminStore store =
      widget.store ?? AdminStore(api: HttpAdminGateway(baseUrl: ''));
  final email = TextEditingController();
  final password = TextEditingController();
  bool passwordVisible = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email dan kata sandi admin.')),
      );
      return;
    }
    try {
      await store.login(email.text, password.text);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => store.authenticated
        ? AdminShell(store: store)
        : AppPage(
            title: 'Login Admin',
            eyebrow: 'AKSES PENELITI',
            subtitle: 'Masuk untuk memantau data peserta secara aman.',
            children: [
              if (store.error != null) ...[
                InfoBox(store.error!, warm: true, label: 'Belum berhasil'),
                const SizedBox(height: 18),
              ],
              TextField(
                controller: email,
                enabled: !store.loading,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                decoration: const InputDecoration(
                  labelText: 'Email admin',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: password,
                enabled: !store.loading,
                obscureText: !passwordVisible,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => login(),
                decoration: InputDecoration(
                  labelText: 'Kata sandi',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => passwordVisible = !passwordVisible),
                    tooltip: passwordVisible
                        ? 'Sembunyikan kata sandi'
                        : 'Tampilkan kata sandi',
                    icon: Icon(
                      passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: store.loading ? null : login,
                icon: store.loading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(store.loading ? 'Memeriksa…' : 'Masuk'),
              ),
            ],
          ),
  );
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key, required this.store});

  final AdminStore store;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int selectedIndex = 0;

  static const titles = ['Dashboard', 'Peserta', 'Buku Harian', 'Analitik'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ensureLoaded(0));
  }

  Future<void> ensureLoaded(int index) async {
    try {
      switch (index) {
        case 0:
          if (widget.store.dashboard == null &&
              !widget.store.dashboardLoading) {
            await widget.store.loadDashboard();
          }
        case 1:
          if (widget.store.participantPage == null &&
              !widget.store.participantsLoading) {
            await widget.store.loadParticipants();
          }
        case 2:
          if (widget.store.diaryParticipantPage == null &&
              !widget.store.diaryParticipantsLoading) {
            await widget.store.loadDiaryParticipants();
          }
        case 3:
          if (widget.store.analytics == null &&
              !widget.store.analyticsLoading) {
            await widget.store.loadAnalytics();
          }
      }
    } catch (_) {}
  }

  void select(int index) {
    setState(() => selectedIndex = index);
    ensureLoaded(index);
  }

  Future<void> confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari admin?'),
        content: const Text(
          'Anda perlu memasukkan email dan kata sandi untuk masuk kembali.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed == true) await widget.store.logout();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminDashboardPage(store: widget.store),
      AdminParticipantsPage(store: widget.store),
      AdminDiaryPage(store: widget.store),
      AdminAnalyticsPage(store: widget.store),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(titles[selectedIndex]),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menu admin',
            onSelected: (value) {
              if (value == 'logout') confirmLogout();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded),
                    SizedBox(width: 12),
                    Text('Keluar dari admin'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 760) {
            return Row(
              children: [
                NavigationRail(
                  extended: true,
                  minExtendedWidth: 220,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: select,
                  leading: const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: BrandLockup(),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline_rounded),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: Text('Peserta'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.book_outlined),
                      selectedIcon: Icon(Icons.book_rounded),
                      label: Text('Buku Harian'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.analytics_outlined),
                      selectedIcon: Icon(Icons.analytics_rounded),
                      label: Text('Analitik'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IndexedStack(index: selectedIndex, children: pages),
                ),
              ],
            );
          }
          return IndexedStack(index: selectedIndex, children: pages);
        },
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 760
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: select,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  selectedIcon: Icon(Icons.people_rounded),
                  label: 'Peserta',
                ),
                NavigationDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book_rounded),
                  label: 'Buku Tidur',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics_rounded),
                  label: 'Analitik',
                ),
              ],
            )
          : null,
    );
  }
}

/// Compatibility preview route used by the rendering test.
class AnalyticsPreviewPage extends StatelessWidget {
  const AnalyticsPreviewPage({super.key});

  @override
  Widget build(BuildContext context) => const AppPage(
    title: 'Analitik Peserta',
    eyebrow: 'ADMIN',
    subtitle: 'Masuk sebagai admin untuk melihat data terbaru.',
    children: [InfoBox('Data analitik hanya tersedia setelah login admin.')],
  );
}
