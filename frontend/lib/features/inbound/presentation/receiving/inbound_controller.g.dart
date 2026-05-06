// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InboundController)
final inboundControllerProvider = InboundControllerProvider._();

final class InboundControllerProvider
    extends $NotifierProvider<InboundController, AsyncValue<InboundItem?>> {
  InboundControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboundControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboundControllerHash();

  @$internal
  @override
  InboundController create() => InboundController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<InboundItem?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<InboundItem?>>(value),
    );
  }
}

String _$inboundControllerHash() => r'75333157074b42d98d4c1ece7c539e26749a292e';

abstract class _$InboundController extends $Notifier<AsyncValue<InboundItem?>> {
  AsyncValue<InboundItem?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<InboundItem?>, AsyncValue<InboundItem?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<InboundItem?>, AsyncValue<InboundItem?>>,
              AsyncValue<InboundItem?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
