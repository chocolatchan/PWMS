// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recall_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Phase6Controller)
final phase6ControllerProvider = Phase6ControllerProvider._();

final class Phase6ControllerProvider
    extends $NotifierProvider<Phase6Controller, Phase6State> {
  Phase6ControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phase6ControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phase6ControllerHash();

  @$internal
  @override
  Phase6Controller create() => Phase6Controller();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Phase6State value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Phase6State>(value),
    );
  }
}

String _$phase6ControllerHash() => r'ef748a6425204fedb9a838c0881d8f4ad0881294';

abstract class _$Phase6Controller extends $Notifier<Phase6State> {
  Phase6State build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Phase6State, Phase6State>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Phase6State, Phase6State>,
              Phase6State,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
