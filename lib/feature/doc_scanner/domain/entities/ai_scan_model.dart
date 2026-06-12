import '../../../../core/constants/value_const.dart';

enum AiModelProvider { gemini, claude, groq }

class AiScanModel {
  final String id;
  final String displayName;
  final String subtitle;
  final String modelId;
  final AiModelProvider provider;

  const AiScanModel({
    required this.id,
    required this.displayName,
    required this.subtitle,
    required this.modelId,
    required this.provider,
  });

  static const groqLlama4Scout = AiScanModel(
    id: ValueConst.aiModelGroqId,
    displayName: ValueConst.aiModelGroqName,
    subtitle: ValueConst.aiModelGroqSubtitle,
    modelId: ValueConst.aiModelGroqModelId,
    provider: AiModelProvider.groq,
  );

  static const claudeHaiku = AiScanModel(
    id: ValueConst.aiModelClaudeId,
    displayName: ValueConst.aiModelClaudeName,
    subtitle: ValueConst.aiModelClaudeSubtitle,
    modelId: ValueConst.aiModelClaudeModelId,
    provider: AiModelProvider.claude,
  );

  static const geminiFlash = AiScanModel(
    id: ValueConst.aiModelGeminiId,
    displayName: ValueConst.aiModelGeminiName,
    subtitle: ValueConst.aiModelGeminiSubtitle,
    modelId: ValueConst.aiModelGeminiModelId,
    provider: AiModelProvider.gemini,
  );

  static const all = [groqLlama4Scout, claudeHaiku, geminiFlash];
  static const defaultModel = groqLlama4Scout;

  @override
  bool operator ==(Object other) => other is AiScanModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
