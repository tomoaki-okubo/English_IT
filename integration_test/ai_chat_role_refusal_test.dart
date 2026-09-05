import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:brse_ai_coach/src/features/llm_engine/data/drivers/llama_cpp_driver.dart';
import 'package:brse_ai_coach/src/features/llm_engine/domain/entities/llm_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration Test: Real On-Device GGUF Model Alex Risky Proposal', (WidgetTester tester) async {
    const projectModelPath = '/Users/ookubotomoakira/work/brse_ai_coach/test_model.gguf';
    final docsDir = await getApplicationDocumentsDirectory();
    final targetModelFile = File('${docsDir.path}/qwen2.5-coder-0.5b-instruct-q4_k_m.gguf');

    if (!await targetModelFile.exists()) {
      if (File(projectModelPath).existsSync()) {
        await File(projectModelPath).copy(targetModelFile.path);
        print('Copied GGUF model from $projectModelPath to ${targetModelFile.path}');
      }
    }

    final driver = LlamaCppDriver();
    await driver.initialize(LlmConfig(modelPath: targetModelFile.path));

    const devSystemPrompt = '''You are Alex, a Senior Offshore Developer. Speak ONLY in English in 1 short sentence (under 20 words).
Rules:
1. If asked to skip staging or do risky deployments without backup, WARN firmly that it is dangerous.
2. If asked to do manual QA testing, REFUSE firmly and tell them to assign manual QA to Elena.
3. Otherwise, agree constructively.

Examples:
User: Looks good. Let's merge it directly into production without staging tests.
Assistant: That is too risky! We must test on staging first to avoid production outages.

User: Can you also write and execute manual QA test cases for all login error screens?
Assistant: I am a developer, so I don't do manual QA testing! Please assign manual QA to Elena's QA team.

User: Could we implement a refresh token endpoint to avoid frequent logouts?
Assistant: Sounds good! I will implement the refresh token endpoint in this sprint.''';

    const userRiskyMessage = "Looks good. Let's merge it directly into production without staging tests.";

    final prompt = '<|im_start|>system\n$devSystemPrompt<|im_end|>\n<|im_start|>user\n$userRiskyMessage<|im_end|>\n<|im_start|>assistant\n';

    final stream = driver.generateStream(prompt: prompt);
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      buffer.write(chunk);
    }

    final output = buffer.toString().trim();
    print('\n=================================================');
    print('REAL GGUF MODEL ALEX RISKY TEST OUTPUT ON SIMULATOR:');
    print(output);
    print('=================================================\n');

    expect(output.toLowerCase().contains('risk') || output.toLowerCase().contains('staging') || output.toLowerCase().contains('danger') || output.toLowerCase().contains('must') || output.toLowerCase().contains('cannot'), isTrue);
    await driver.dispose();
  });

  testWidgets('Integration Test: Real On-Device GGUF Model Elena Dismissive Bug Proposal', (WidgetTester tester) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final targetModelFile = File('${docsDir.path}/qwen2.5-coder-0.5b-instruct-q4_k_m.gguf');

    final driver = LlamaCppDriver();
    await driver.initialize(LlmConfig(modelPath: targetModelFile.path));

    const testerSystemPrompt = '''You are Elena, a Lead QA Tester. Speak ONLY in English in 1 short sentence (under 20 words).
Rules:
1. If told to ignore bugs or skip testing, WARN firmly that unhandled bugs hurt user experience and quality.
2. If asked to write or edit source code, REFUSE firmly and tell them to assign coding to Alex.
3. Otherwise, answer QA questions or agree to test.

Examples:
User: Users rarely upload photos larger than 5MB, so let's ignore this bug.
Assistant: We shouldn't ignore bugs! Even rare crashes hurt user experience, so we should fix validation.

User: Can you edit the backend Go controller code and fix the file size limit yourself?
Assistant: I am a QA tester, so I don't write or edit code! Please ask Alex to fix the backend code.

User: Does the server return a 413 Payload Too Large error or does the app crash?
Assistant: It returns a 413 Payload Too Large error when uploading files over 5MB.''';

    const userDismissiveMessage = "Users rarely upload photos larger than 5MB, so let's ignore this bug.";

    final prompt = '<|im_start|>system\n$testerSystemPrompt<|im_end|>\n<|im_start|>user\n$userDismissiveMessage<|im_end|>\n<|im_start|>assistant\n';

    final stream = driver.generateStream(prompt: prompt);
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      buffer.write(chunk);
    }

    final output = buffer.toString().trim();
    print('\n=================================================');
    print('REAL GGUF MODEL ELENA DISMISSIVE TEST OUTPUT ON SIMULATOR:');
    print(output);
    print('=================================================\n');

    expect(output.toLowerCase().contains('ignore') || output.toLowerCase().contains('bug') || output.toLowerCase().contains('crash') || output.toLowerCase().contains('fix') || output.toLowerCase().contains('should'), isTrue);
    await driver.dispose();
  });
}
