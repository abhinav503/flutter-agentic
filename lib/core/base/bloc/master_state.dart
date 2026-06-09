part of 'master_bloc.dart';

sealed class MasterState {}

final class MasterInitial extends MasterState {}

final class MasterLoading extends MasterState {}

final class MasterIdle extends MasterState {}
