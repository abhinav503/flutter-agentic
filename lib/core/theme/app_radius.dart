import 'package:flutter/material.dart';

/// Design-token border-radius scale.
///
/// Usage:  `borderRadius: AppRadius.md`
class AppRadius {
  AppRadius._();

  static const double smValue = 4;
  static const double mdValue = 8;
  static const double lgValue = 12;
  static const double xlValue = 16;
  static const double fullValue = 999;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullValue));
}
