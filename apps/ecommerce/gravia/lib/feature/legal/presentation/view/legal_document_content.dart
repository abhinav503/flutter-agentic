import 'package:gravia/constants/value_const.dart';

/// Static copy for a [LegalDocumentScreen] — Terms & Conditions and Privacy
/// Policy are the same layout with different copy, so one screen serves
/// both rather than forking a near-identical widget per document.
class LegalDocumentContent {
  final String title;
  final String lastUpdated;
  final String intro;
  final String heading;
  final String body;

  const LegalDocumentContent({
    required this.title,
    required this.lastUpdated,
    required this.intro,
    required this.heading,
    required this.body,
  });

  factory LegalDocumentContent.termsAndConditions() =>
      const LegalDocumentContent(
        title: ValueConst.termsAndConditionsLabel,
        lastUpdated: ValueConst.legalLastUpdatedLabel,
        intro: ValueConst.termsAndConditionsIntro,
        heading: ValueConst.termsAndConditionsHeading,
        body: ValueConst.termsAndConditionsBody,
      );

  factory LegalDocumentContent.privacyPolicy() => const LegalDocumentContent(
    title: ValueConst.privacyPolicyLabel,
    lastUpdated: ValueConst.legalLastUpdatedLabel,
    intro: ValueConst.privacyPolicyIntro,
    heading: ValueConst.privacyPolicyHeading,
    body: ValueConst.privacyPolicyBody,
  );
}
