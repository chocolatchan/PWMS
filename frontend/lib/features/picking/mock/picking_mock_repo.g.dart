// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picking_mock_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mockPickingRepo)
final mockPickingRepoProvider = MockPickingRepoProvider._();

final class MockPickingRepoProvider
    extends
        $FunctionalProvider<
          MockPickingRepository,
          MockPickingRepository,
          MockPickingRepository
        >
    with $Provider<MockPickingRepository> {
  MockPickingRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockPickingRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockPickingRepoHash();

  @$internal
  @override
  $ProviderElement<MockPickingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MockPickingRepository create(Ref ref) {
    return mockPickingRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockPickingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockPickingRepository>(value),
    );
  }
}

String _$mockPickingRepoHash() => r'dc2bfd364e92528ffbb76907b63a3fecdabeb5f3';
