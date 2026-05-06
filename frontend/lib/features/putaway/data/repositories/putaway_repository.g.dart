// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putaway_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(putawayRepository)
final putawayRepositoryProvider = PutawayRepositoryProvider._();

final class PutawayRepositoryProvider
    extends
        $FunctionalProvider<
          PutawayRepository,
          PutawayRepository,
          PutawayRepository
        >
    with $Provider<PutawayRepository> {
  PutawayRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'putawayRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$putawayRepositoryHash();

  @$internal
  @override
  $ProviderElement<PutawayRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PutawayRepository create(Ref ref) {
    return putawayRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PutawayRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PutawayRepository>(value),
    );
  }
}

String _$putawayRepositoryHash() => r'8a55c65d299f44148c1c623b2ad91e290f691a3d';
