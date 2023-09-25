// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_schedule_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeScheduleViewModelHash() =>
    r'f3a72dfe6e0932bf542de0a0ad728499d9495e9f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$EmployeeScheduleViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<ScheduleModel>> {
  late final int userId;
  late final DateTime date;

  Future<List<ScheduleModel>> build(
    int userId,
    DateTime date,
  );
}

/// See also [EmployeeScheduleViewModel].
@ProviderFor(EmployeeScheduleViewModel)
const employeeScheduleViewModelProvider = EmployeeScheduleViewModelFamily();

/// See also [EmployeeScheduleViewModel].
class EmployeeScheduleViewModelFamily
    extends Family<AsyncValue<List<ScheduleModel>>> {
  /// See also [EmployeeScheduleViewModel].
  const EmployeeScheduleViewModelFamily();

  /// See also [EmployeeScheduleViewModel].
  EmployeeScheduleViewModelProvider call(
    int userId,
    DateTime date,
  ) {
    return EmployeeScheduleViewModelProvider(
      userId,
      date,
    );
  }

  @override
  EmployeeScheduleViewModelProvider getProviderOverride(
    covariant EmployeeScheduleViewModelProvider provider,
  ) {
    return call(
      provider.userId,
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'employeeScheduleViewModelProvider';
}

/// See also [EmployeeScheduleViewModel].
class EmployeeScheduleViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EmployeeScheduleViewModel,
        List<ScheduleModel>> {
  /// See also [EmployeeScheduleViewModel].
  EmployeeScheduleViewModelProvider(
    this.userId,
    this.date,
  ) : super.internal(
          () => EmployeeScheduleViewModel()
            ..userId = userId
            ..date = date,
          from: employeeScheduleViewModelProvider,
          name: r'employeeScheduleViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$employeeScheduleViewModelHash,
          dependencies: EmployeeScheduleViewModelFamily._dependencies,
          allTransitiveDependencies:
              EmployeeScheduleViewModelFamily._allTransitiveDependencies,
        );

  final int userId;
  final DateTime date;

  @override
  bool operator ==(Object other) {
    return other is EmployeeScheduleViewModelProvider &&
        other.userId == userId &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Future<List<ScheduleModel>> runNotifierBuild(
    covariant EmployeeScheduleViewModel notifier,
  ) {
    return notifier.build(
      userId,
      date,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
