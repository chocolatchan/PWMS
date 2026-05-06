// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InboundTaskNotifier)
final inboundTaskProvider = InboundTaskNotifierProvider._();

final class InboundTaskNotifierProvider
    extends $AsyncNotifierProvider<InboundTaskNotifier, InboundState> {
  InboundTaskNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboundTaskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboundTaskNotifierHash();

  @$internal
  @override
  InboundTaskNotifier create() => InboundTaskNotifier();
}

String _$inboundTaskNotifierHash() =>
    r'3974394effaf8a6c673ce8f8e1ad1bbd14a2ecb7';

abstract class _$InboundTaskNotifier extends $AsyncNotifier<InboundState> {
  FutureOr<InboundState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<InboundState>, InboundState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<InboundState>, InboundState>,
              AsyncValue<InboundState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
