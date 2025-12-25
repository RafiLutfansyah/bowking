import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/presentation/cubit/current_user_cubit.dart';
import 'core/presentation/payment/payment_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/booking/presentation/pages/services_page.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'features/wallet/presentation/pages/wallet_page.dart';
import 'features/rewards/presentation/bloc/rewards_bloc.dart';
import 'features/rewards/presentation/pages/rewards_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CurrentUserCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => di.sl<BookingBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<WalletBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<PaymentBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<RewardsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Bowking',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.read<CurrentUserCubit>().setUser(state.user);
            } else if (state is Unauthenticated) {
              context.read<CurrentUserCubit>().clearUser();
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading || state is AuthInitial) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (state is Authenticated) {
                return const MainNavigation();
              }
              
              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ServicesPage(),
    WalletPage(),
    RewardsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Safety check untuk memastikan index valid
    if (_selectedIndex >= _pages.length) {
      _selectedIndex = 0;
    }
    
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_car_wash),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
