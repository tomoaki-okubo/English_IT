import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

void main() {
  test('Real GGUF Model Inference - Alex Role Refusal Test', () async {
    String modelPath = '';
    final simDir = Directory('/Users/ookubotomoakira/Library/Developer/CoreSimulator/Devices');
    if (simDir.existsSync()) {
      try {
        for (final device in simDir.listSync()) {
          final docsDir = Directory('${device.path}/data/Containers/Data/Application');
          if (docsDir.existsSync()) {
            for (final app in docsDir.listSync()) {
              final target = File('${app.path}/Documents/qwen2.5-coder-0.5b-instruct-q4_k_m.gguf');
              if (target.existsSync()) {
                modelPath = target.path;
                break;
              }
            }
          }
          if (modelPath.isNotEmpty) break;
        }
      } catch (_) {}
    }
    const dylibPath = '/Users/ookubotomoakira/work/brse_ai_coach/build/ios/Debug-iphonesimulator/XCFrameworkIntermediates/llama_cpp_dart/Llama.framework/Frameworks/libllama.dylib';

    if (modelPath.isEmpty || !File(modelPath).existsSync()) {
      print('Skip: Model file not found dynamically in Simulator directory');
      return;
    }

    if (File(dylibPath).existsSync()) {
      try {
        DynamicLibrary.open(dylibPath);
        Llama.libraryPath = dylibPath;
        print('Successfully loaded libllama.dylib: $dylibPath');
      } catch (e) {
        print('Notice on dylib load: $e');
      }
    }

    const devSystemPrompt = '''You are Alex, a Senior Offshore Full-Stack Developer talking to a Bridge SE.
Language: Speak ONLY in English.
Role: You write backend/frontend code, design APIs, and handle software architecture.
CRITICAL ROLE BOUNDARY:
- You strictly REFUSE to do manual QA testing or write manual QA test cases! ("I am a developer! I write code and unit tests, but manual QA testing must be done by Elena's QA team.")
Rules for reply:
1. Keep replies under 25 words (1-2 sentences).
2. If asked to do manual QA testing or manual testing, REFUSE firmly and tell them to assign manual QA to Elena.
3. Otherwise, agree constructively to technical proposals.''';

    const userRoleTriggerMessage = "Can you also write and execute manual QA test cases for all login error screens?";

    final prompt = '<|im_start|>system\n$devSystemPrompt\n[CRITICAL RULE]: Reply in 1 or 2 short sentences ONLY (under 25 words). Directly respond to the user\'s message while strictly respecting your role boundaries (refuse tasks outside your role).<|im_end|>\n<|im_start|>user\n$userRoleTriggerMessage<|im_end|>\n<|im_start|>assistant\n';

    final mp = ModelParams()..nGpuLayers = 0;
    final cp = ContextParams()..nCtx = 1024;
    final sp = SamplerParams();

    final loadCommand = LlamaLoad(
      path: modelPath,
      modelParams: mp,
      contextParams: cp,
      samplingParams: sp,
    );

    final parent = LlamaParent(loadCommand);
    await parent.init();

    final completer = Completer<String>();
    final buffer = StringBuffer();

    final tokenSub = parent.stream.listen((chunk) {
      if (chunk.contains('<|im_end|>') || chunk.contains('<|im_start|>') || chunk.contains('<|endoftext|>')) {
        final cleanChunk = chunk
            .split('<|im_end|>').first
            .split('<|im_start|>').first
            .split('<|endoftext|>').first;
        buffer.write(cleanChunk);
        if (!completer.isCompleted) completer.complete(buffer.toString());
      } else {
        buffer.write(chunk);
      }
    });

    final promptId = await parent.sendPrompt(prompt);

    final compSub = parent.completions.listen((event) {
      if (event.promptId == promptId || event.promptId.isEmpty) {
        if (!completer.isCompleted) completer.complete(buffer.toString());
      }
    });

    final output = await completer.future.timeout(const Duration(seconds: 30), onTimeout: () {
      return buffer.toString();
    });

    print('\n========================================');
    print('ACTUAL Qwen2.5-Coder GGUF MODEL OUTPUT:');
    print(output.trim());
    print('========================================\n');

    await tokenSub.cancel();
    await compSub.cancel();
    await parent.dispose();

    expect(output.isNotEmpty, isTrue);
  });
}
