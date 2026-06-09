part of 'master_bloc.dart';

sealed class MasterEvent {}

final class ShowLoader extends MasterEvent {}

final class HideLoader extends MasterEvent {}
