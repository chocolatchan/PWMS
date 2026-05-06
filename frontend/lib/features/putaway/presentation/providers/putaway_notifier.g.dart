// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putaway_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PutawayTaskNotifier)
final putawayTaskProvider = PutawayTaskNotifierProvider._();

final class PutawayTaskNotifierProvider
    extends $AsyncNotifierProvider<PutawayTaskNotifier, PutawayState> {
  PutawayTaskNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'putawayTaskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$putawayTaskNotifierHash();

  @$internal
  @override
  PutawayTaskNotifier create() => PutawayTaskNotifier();
}

String _$putawayTaskNotifierHash() =>
    r'66ed554eb4ece501dbcb3fc9f8348e761c1ecfdb';

abstract class _$PutawayTaskNotifier extends $AsyncNotifier<PutawayState> {
  FutureOr<PutawayState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PutawayState>, PutawayState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PutawayState>, PutawayState>,
              AsyncValue<PutawayState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
