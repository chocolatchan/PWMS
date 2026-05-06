// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbound_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OutboundController)
final outboundControllerProvider = OutboundControllerProvider._();

final class OutboundControllerProvider
    extends $NotifierProvider<OutboundController, OutboundState> {
  OutboundControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outboundControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outboundControllerHash();

  @$internal
  @override
  OutboundController create() => OutboundController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OutboundState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OutboundState>(value),
    );
  }
}

String _$outboundControllerHash() =>
    r'3a0fc43618f73fe44886d64f8f4114a6e7802037';

abstract class _$OutboundController extends $Notifier<OutboundState> {
  OutboundState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OutboundState, OutboundState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OutboundState, OutboundState>,
              OutboundState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
