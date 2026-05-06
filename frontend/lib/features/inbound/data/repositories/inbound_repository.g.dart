// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inboundRepository)
final inboundRepositoryProvider = InboundRepositoryProvider._();

final class InboundRepositoryProvider
    extends
        $FunctionalProvider<
          InboundRepository,
          InboundRepository,
          InboundRepository
        >
    with $Provider<InboundRepository> {
  InboundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboundRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboundRepositoryHash();

  @$internal
  @override
  $ProviderElement<InboundRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InboundRepository create(Ref ref) {
    return inboundRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InboundRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InboundRepository>(value),
    );
  }
}

String _$inboundRepositoryHash() => r'715060fb37d369bfecfe6fbaab927a526fe9e8f6';
