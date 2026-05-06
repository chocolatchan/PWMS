// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminTowerController)
final adminTowerControllerProvider = AdminTowerControllerProvider._();

final class AdminTowerControllerProvider
    extends $NotifierProvider<AdminTowerController, AdminState> {
  AdminTowerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminTowerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminTowerControllerHash();

  @$internal
  @override
  AdminTowerController create() => AdminTowerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminState>(value),
    );
  }
}

String _$adminTowerControllerHash() =>
    r'5736645713decbd402181f2d5cb75dd7dad20669';

abstract class _$AdminTowerController extends $Notifier<AdminState> {
  AdminState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AdminState, AdminState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminState, AdminState>,
              AdminState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
