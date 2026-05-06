import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pwms_frontend/core/network/dio_client.dart';
import 'package:pwms_frontend/core/router/app_router.dart';
import 'package:pwms_frontend/core/storage/secure_storage_service.dart';

import 'package:pwms_frontend/core/hardware/audio_service.dart';
import 'package:pwms_frontend/core/hardware/haptic_service.dart';
import 'package:pwms_frontend/core/hardware/scanner_service.dart';

import 'package:pwms_frontend/features/auth/data/auth_api_client.dart';
import 'package:pwms_frontend/features/auth/data/auth_repository.dart';
import 'package:pwms_frontend/features/auth/bloc/auth_bloc.dart';

import 'package:pwms_frontend/features/outbound/data/outbound_api_client.dart';
import 'package:pwms_frontend/features/outbound/data/outbound_repository.dart';
import 'package:pwms_frontend/features/outbound/bloc/outbound_bloc.dart';

import 'package:pwms_frontend/features/inbound/data/inbound_api_client.dart';
import 'package:pwms_frontend/features/inbound/data/inbound_repository.dart';
import 'package:pwms_frontend/features/inbound/bloc/inbound_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Hardware
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<HapticService>(() => HapticService());
  getIt.registerLazySingleton<ScannerService>(() => ScannerService());

  // Storage
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // Network
  getIt.registerSingleton<DioClient>(DioClient());

  // Auth
  getIt.registerLazySingleton<AuthApiClient>(
    () => AuthApiClient(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthApiClient>(), getIt<SecureStorageService>()),
  );
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  // Inbound
  getIt.registerLazySingleton<InboundApiClient>(
    () => InboundApiClient(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<InboundRepository>(
    () => InboundRepository(getIt<InboundApiClient>()),
  );
  getIt.registerFactory<InboundBloc>(
    () => InboundBloc(
      getIt<InboundRepository>(),
      getIt<AudioService>(),
      getIt<HapticService>(),
    ),
  );

  // Outbound
  getIt.registerLazySingleton<OutboundApiClient>(
    () => OutboundApiClient(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<OutboundRepository>(
    () => OutboundRepository(getIt<OutboundApiClient>()),
  );
  getIt.registerFactory<OutboundBloc>(
    () => OutboundBloc(
      getIt<OutboundRepository>(),
      getIt<AudioService>(),
      getIt<HapticService>(),
    ),
  );

  // Router
  getIt.registerSingleton<GoRouter>(AppRouter.router);
}
