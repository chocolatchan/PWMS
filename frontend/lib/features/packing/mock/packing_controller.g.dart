// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PackingWizardController)
final packingWizardControllerProvider = PackingWizardControllerProvider._();

final class PackingWizardControllerProvider
    extends $NotifierProvider<PackingWizardController, PackingWizardState> {
  PackingWizardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packingWizardControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packingWizardControllerHash();

  @$internal
  @override
  PackingWizardController create() => PackingWizardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PackingWizardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PackingWizardState>(value),
    );
  }
}

String _$packingWizardControllerHash() =>
    r'9ffcf8f4d092195809a9f7624cd8b37fef531dd0';

abstract class _$PackingWizardController extends $Notifier<PackingWizardState> {
  PackingWizardState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PackingWizardState, PackingWizardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PackingWizardState, PackingWizardState>,
              PackingWizardState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
