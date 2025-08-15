import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isp_app/core/di/service_locator.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/usecases/get_user_data.dart';
import 'package:isp_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:isp_app/presentation/blocs/user/user_bloc.dart';
import 'package:isp_app/presentation/widgets/custom_app_bar.dart';
import 'package:isp_app/presentation/widgets/data_usage_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get authenticated user
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    
    // Initialize UserBloc
    return BlocProvider(
      create: (context) => UserBloc(getUserData: getIt<GetUserData>())
        ..add(LoadUserData(user.id)),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'My account',
          showLogout: true,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.user;
              return _buildDashboard(context, user);
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, User user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          if (user.isGuest)
            _buildGuestWarning(),


          Text(
            'Hi, ${user.name}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Plan: ${user.planName}',
            style: TextStyle(
              fontSize: 18, 
              color: colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 30),
          DataUsageCard(
            used: user.dataUsage,
            total: user.dataLimit,
          ),
          const SizedBox(height: 30),
          _buildInfoCard(context, 'Current billing', '\$${user.monthlyPayment}'),
          const SizedBox(height: 15),
          _buildInfoCard(context, 'Next billing', '15 each month'),
          const SizedBox(height: 15),
          _buildInfoCard(context, 'Account status', 'Up to date'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('View contracted services'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, 
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCF40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Color(0xFFDD8500)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Guest mode: Data test',
              style: TextStyle(color: const Color(0xFFB45100)),
            ),
          ),
        ],
      ),
    );
  }
}