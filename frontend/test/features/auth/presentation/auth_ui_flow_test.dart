import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwms_frontend/core/constants/app_permissions.dart';
import 'package:pwms_frontend/core/router/app_router.dart';
import 'package:pwms_frontend/core/storage/storage_service.dart';
import 'package:pwms_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:pwms_frontend/features/auth/domain/auth_repository.dart';
import 'package:pwms_frontend/features/auth/domain/auth_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockStorageService mockStorageService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockStorageService = MockStorageService();

    // Default mock behavior for Storage
    when(() => mockStorageService.getToken()).thenAnswer((_) async => null);
    when(() => mockStorageService.getPermissions()).thenAnswer((_) async => []);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        storageServiceProvider.overrideWithValue(mockStorageService),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          final router = ref.watch(appRouterProvider);
          return MaterialApp.router(
            routerConfig: router,
          );
        },
      ),
    );
  }

  testWidgets('E2E UI Flow: Successful login navigates to Dashboard and respects PBAC', 
    (WidgetTester tester) async {
    // 1. Setup: Mock user with limited permissions
    final mockUser = AuthUser(
      id: 1,
      email: 'pda@pwms.com',
      fullName: 'PDA User',
      permissions: [
        AppPermissions.inboundRead,
        AppPermissions.qcInspect,
      ],
    );

    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => mockUser);
    
    // For session check on startup
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => null);

    // 2. Act: Pump App (Starts at Login due to Guards)
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify we are on Login Screen
    expect(find.text('PWMS Login'), findsOneWidget);

    // Enter credentials
    await tester.enterText(find.byType(TextFormField).at(0), 'pda@pwms.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Tap Login
    await tester.tap(find.byType(ElevatedButton));
    
    // 3. Wait for GoRouter's redirect and transition animation
    await tester.pumpAndSettle();

    // 4. Assert: Navigation successful (Dashboard AppBar Title)
    expect(find.text('PWMS'), findsOneWidget); 

    // 5. Assert: PBAC Visibility (Authorized modules are visible)
    expect(find.textContaining('Inbound'), findsOneWidget);
    expect(find.textContaining('QC Inspection'), findsOneWidget);

    // 6. Assert: PBAC Hidden (Unauthorized modules are removed from tree)
    expect(find.textContaining('Recall'), findsNothing);
    expect(find.textContaining('Thu hồi'), findsNothing);
  });
}
