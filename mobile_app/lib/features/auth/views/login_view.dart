import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/app.dart';
import 'package:mobile_app/features/teacher/views/teacher_dashboard_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Toggle global role provider for real-time theme switching
        ref.read(roleProvider.notifier).state = 
          _tabController.index == 0 ? AuthRole.teacher : AuthRole.parent;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTeacher = ref.watch(roleProvider) == AuthRole.teacher;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Gradient
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.primaryColor, theme.colorScheme.secondary],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        isTeacher ? Icons.assignment_ind_rounded : Icons.family_restroom_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      isTeacher ? 'Teacher Portal' : 'Parent Portal',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Welcome back to DG Smart',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // Login Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab Switcher
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF64748B),
                      labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'Teacher'),
                        Tab(text: 'Parent'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Inputs
                  _buildLabel('Mobile Number / Email ID'),
                  TextField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your credentials',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildLabel('Password'),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.outfit(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // Trigger Login Flow
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const TeacherDashboardView()),
                      );
                    },
                    child: const Text('Login'),
                  ),

                  const SizedBox(height: 30),
                  
                  // Footer Text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 14),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Contact Support',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }
}
