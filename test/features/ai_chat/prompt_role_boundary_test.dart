import 'package:flutter_test/flutter_test.dart';
import 'package:brse_ai_coach/src/features/ai_chat/domain/entities/chat_message.dart';
import 'package:brse_ai_coach/src/features/ai_chat/domain/entities/persona.dart';

void main() {
  group('AI Chat Persona System Prompt & Conversation Flow Tests', () {
    const developerPersona = Persona(
      id: 'dev',
      name: 'Senior Developer (Alex)',
      roleDescription: 'Full-Stack Lead Engineer',
      systemPrompt: '''You are Alex, a Senior Offshore Developer. Speak ONLY in English in 1 short sentence (under 20 words).
You are a developer, so you NEVER do manual QA testing. If asked to do manual QA testing, refuse firmly and tell them to assign manual QA to Elena.

Examples:
User: Can you also write and execute manual QA test cases for all login error screens?
Assistant: I am a developer, so I don't do manual QA testing! Please assign manual QA to Elena's QA team.

User: Could we implement a refresh token endpoint to avoid frequent logouts?
Assistant: Sounds good! I will implement the refresh token endpoint in this sprint.''',
      avatarUrl: '',
    );

    const testerPersona = Persona(
      id: 'tester',
      name: 'Lead QA Tester (Elena)',
      roleDescription: 'QA & Test Automation Specialist',
      systemPrompt: '''You are Elena, a Lead QA Tester. Speak ONLY in English in 1 short sentence (under 20 words).
You are a QA tester, so you NEVER write or edit code. If asked to write or edit source code, refuse firmly and tell them to assign coding to Alex.

Examples:
User: Can you edit the backend Go controller code and fix the file size limit yourself?
Assistant: I am a QA tester, so I don't write or edit code! Please ask Alex to fix the backend code.

User: Does the server return a 413 Payload Too Large error or does the app crash?
Assistant: It returns a 413 Payload Too Large error when uploading files over 5MB.''',
      avatarUrl: '',
    );

    test('Developer System Prompt contains explicit manual QA refusal example', () {
      expect(developerPersona.systemPrompt, contains('NEVER do manual QA testing'));
      expect(developerPersona.systemPrompt, contains("assign manual QA to Elena's QA team"));
    });

    test('Tester System Prompt contains explicit code editing refusal example', () {
      expect(testerPersona.systemPrompt, contains('NEVER write or edit code'));
      expect(testerPersona.systemPrompt, contains('fix the backend code'));
    });

    test('Prompt formatting builds ChatML correctly with system constraints', () {
      final history = [
        ChatMessage(
          id: '1',
          sender: MessageSender.ai,
          content: "Hey! Have you had a chance to review the spec document?",
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '2',
          sender: MessageSender.user,
          content: "Can you also write and execute manual QA test cases for all login error screens?",
          timestamp: DateTime.now(),
        ),
      ];

      final buffer = StringBuffer();
      buffer.writeln('<|im_start|>system');
      buffer.writeln(developerPersona.systemPrompt);
      buffer.writeln('\n[CRITICAL RULE]: Reply in 1 or 2 short sentences ONLY (under 25 words). Directly respond to the user\'s message while strictly respecting your role boundaries (refuse tasks outside your role).');
      buffer.writeln('<|im_end|>');

      for (final msg in history) {
        final role = msg.sender == MessageSender.user ? 'user' : 'assistant';
        buffer.writeln('<|im_start|>$role');
        buffer.writeln(msg.content);
        buffer.writeln('<|im_end|>');
      }
      buffer.write('<|im_start|>assistant\n');

      final fullPrompt = buffer.toString();
      expect(fullPrompt, contains('<|im_start|>system'));
      expect(fullPrompt, contains('Can you also write and execute manual QA test cases'));
      expect(fullPrompt, contains('NEVER do manual QA testing'));
    });
  });
}
