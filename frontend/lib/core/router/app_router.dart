import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/models/auth_models.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/outbound/presentation/picking_screen.dart';
import '../../features/outbound/bloc/outbound_bloc.dart';
import '../../features/inbound/presentation/receipt_list_screen.dart';
import '../../features/inbound/presentation/item_scan_screen.dart';
import '../../features/inbound/presentation/create_receipt_screen.dart';
import '../../features/inbound/bloc/inbound_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/inbound/presentation/mock_demo/inbound_screen.dart';
import '../../features/qc/mock/qc_list_screen.dart';
import '../../features/putaway/mock/putaway_screen.dart';
import '../../features/picking/mock/picking_screen.dart' as mock_picking;
import '../../features/outbound_v2/mock/packing_screen.dart' as mock_packing_v2;
import '../../features/outbound_v2/mock/dispatch_screen.dart' as mock_dispatch_v2;
import '../../features/phase6_returns/mock/phase6_dashboard.dart' as mock_phase6;
import '../../features/admin_tower/mock/admin_dashboard_screen.dart' as mock_admin_tower;

final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => GetIt.I<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) {
          final user = state.extra as LoginResponse?;
          return DashboardScreen(user: user);
        },
      ),
      GoRoute(
        path: '/inbound',
        builder: (context, state) => BlocProvider(
          create: (context) => GetIt.I<InboundBloc>(),
          child: const ReceiptListScreen(),
        ),
      ),
      GoRoute(
        path: '/inbound/create',
        builder: (context, state) => BlocProvider(
          create: (context) => GetIt.I<InboundBloc>(),
          child: const CreateReceiptScreen(),
        ),
      ),
      GoRoute(
        path: '/inbound/scan/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (context) => GetIt.I<InboundBloc>(),
            child: ItemScanScreen(receiptId: id),
          );
        },
      ),
      GoRoute(
        path: '/picking/:taskId',
        builder: (context, state) {
          final taskIdStr = state.pathParameters['taskId']!;
          return BlocProvider(
            create: (context) => GetIt.I<OutboundBloc>(),
            child: PickingScreen(taskId: int.parse(taskIdStr)),
          );
        },
      ),
      GoRoute(
        path: '/inbound/demo',
        builder: (context, state) => const InboundDemoScreen(),
      ),
      GoRoute(
        path: '/qc',
        builder: (context, state) => const QcListScreen(),
      ),
      GoRoute(
        path: '/putaway',
        builder: (context, state) => const PutawayScreen(),
      ),
      GoRoute(
        path: '/picking',
        builder: (context, state) => const mock_picking.PickingScreen(),
      ),
      GoRoute(
        path: '/packing',
        builder: (context, state) => const mock_packing_v2.PackingScreenV2(),
      ),
      GoRoute(
        path: '/dispatch',
        builder: (context, state) => const mock_dispatch_v2.DispatchScreenV2(),
      ),
      GoRoute(
        path: '/phase6',
        builder: (context, state) => const mock_phase6.Phase6Dashboard(),
      ),
      GoRoute(
        path: '/admin-tower',
        builder: (context, state) => const mock_admin_tower.AdminDashboardScreen(),
      ),
    ],
  );
}
