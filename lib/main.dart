import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
//import 'package:playground/secret.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SampleChatGPT(),
    );
  }
}

class SampleChatGPT extends StatefulWidget {
  const SampleChatGPT({super.key});

  @override
  State<SampleChatGPT> createState() => _SampleChatGPTState();
}

class _SampleChatGPTState extends State<SampleChatGPT> {
  String? content;

  final controller = TextEditingController();

  Future<void> sendToChatGPT() async {
    final response = await post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/json',
        // 'OpenAI-Organization': 'org-3kJ8f2NS5osyB5W4JgEzVpha',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content": controller.text,
          }
        ],
      }),
    );

    final jsonResponse = jsonDecode(utf8.decode(response.body.codeUnits))
    as Map<String, dynamic>;

    content =
    (jsonResponse['choices'] as List).first['message']['content'] as String;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller,
            ),
            if (content == null) const Text('結果はまだありません') else Text(content!),
            ElevatedButton(
              onPressed: () {
                sendToChatGPT();
              },
              child: const Text('送信'),
            ),
          ],
        ),
      ),
    );
  }
}
