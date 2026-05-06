// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PickingWizardController)
final pickingWizardControllerProvider = PickingWizardControllerProvider._();

final class PickingWizardControllerProvider
    extends $NotifierProvider<PickingWizardController, PickingWizardState> {
  PickingWizardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pickingWizardControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pickingWizardControllerHash();

  @$internal
  @override
  PickingWizardController create() => PickingWizardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PickingWizardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PickingWizardState>(value),
    );
  }
}

String _$pickingWizardControllerHash() =>
    r'8c369e5d9e9bedaca9d4ae92e93fe5ee67aef9eb';

abstract class _$PickingWizardController extends $Notifier<PickingWizardState> {
  PickingWizardState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PickingWizardState, PickingWizardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PickingWizardState, PickingWizardState>,
              PickingWizardState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
