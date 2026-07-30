import 'package:cordelia/constants/value_const.dart';

/// One numbered clause of a legal document — a heading and its paragraph.
class LegalDocumentSection {
  final String heading;
  final String body;

  const LegalDocumentSection({required this.heading, required this.body});
}

/// Static copy for a [LegalDocumentScreen] — Terms & Conditions and Privacy
/// Policy are the same layout with different copy, so one screen serves
/// both rather than forking a near-identical widget per document.
///
/// [intro] is a lead paragraph gravia prints above the clauses; the DailyMart
/// kit's frame has no slot for it and prints [sections] straight after the
/// date, so that template drops it.
class LegalDocumentContent {
  final String title;
  final String lastUpdated;
  final String intro;
  final List<LegalDocumentSection> sections;

  const LegalDocumentContent({
    required this.title,
    required this.lastUpdated,
    required this.intro,
    required this.sections,
  });

  factory LegalDocumentContent.termsAndConditions() =>
      const LegalDocumentContent(
        title: ValueConst.termsAndConditionsLabel,
        lastUpdated: ValueConst.legalLastUpdatedLabel,
        intro: ValueConst.termsAndConditionsIntro,
        sections: [
          LegalDocumentSection(
            heading: ValueConst.termsAndConditionsHeading,
            body: ValueConst.termsAndConditionsBody,
          ),
        ],
      );

  factory LegalDocumentContent.privacyPolicy() => const LegalDocumentContent(
    title: ValueConst.privacyPolicyLabel,
    lastUpdated: ValueConst.legalLastUpdatedLabel,
    intro: ValueConst.privacyPolicyIntro,
    sections: [
      LegalDocumentSection(
        heading: ValueConst.privacyPolicySection1Heading,
        body: ValueConst.privacyPolicySection1Body,
      ),
      LegalDocumentSection(
        heading: ValueConst.privacyPolicySection2Heading,
        body: ValueConst.privacyPolicySection2Body,
      ),
      LegalDocumentSection(
        heading: ValueConst.privacyPolicySection3Heading,
        body: ValueConst.privacyPolicySection3Body,
      ),
      LegalDocumentSection(
        heading: ValueConst.privacyPolicySection4Heading,
        body: ValueConst.privacyPolicySection4Body,
      ),
    ],
  );
}
