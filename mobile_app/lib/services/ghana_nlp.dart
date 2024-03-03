import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:test_1/components/create_folder.dart';

class SpeechToText {
  static const BASE_URL = 'https://translation-api.ghananlp.org/asr/v1/transcribe?language=tw&wav=False';
  final String apiKey;

  SpeechToText(this.apiKey);

  Future<String?> speechToText(String recordedAudioPath) async {
    File audioFile = File(recordedAudioPath);
    if (!await audioFile.exists()) {
      throw Exception("Audio file not found.\n");
    }
    try {
      final bytes = await audioFile.readAsBytes();

      final response = await http.post(Uri.parse(BASE_URL),
          headers: {
            "Content-Type": "audio/m4a",
            "Cache-Control": "no-cache",
            "Ocp-Apim-Subscription-Key": apiKey
          },
          body: bytes);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(jsonEncode(response.body));
        }
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch text data: ${response.statusCode}");
      }
    } catch (e) {
      if(kDebugMode) {
        print(e);
      }
    }
  }
}

class TextToSpeech {
  static const BASE_URL = 'https://translation-api.ghananlp.org/tts/v1/tts';
  final String apiKey;

  TextToSpeech(this.apiKey);

  Future<void> textToSpeech(String text, {String? targetLanguage, required int textContentType}) async {
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {
          "Content-Type": "application/json",
          "Cache-Control": "no-cache",
          "Ocp-Apim-Subscription-Key": apiKey
        },
        body: jsonEncode({"text": text, "language": "tw"}));

    if (response.statusCode == 200) {
      List<int> audioData = response.bodyBytes;

      /// Create dir if notExist and save the audio to the file
      final directoryPath = await createFolder('audio_recorded');

      late final String fileName;
      if (textContentType == 0) {
        fileName = "welcome_note_3.wav";
      } else if (textContentType == 1) {
        fileName = "Weather_voice.wav";
      } else if (textContentType == 2) {
        fileName = "Gemini_voice.wav";
      } else if (textContentType == 3) {
        fileName = "crop_disease_voice.wav";
      }

      final filePath = '$directoryPath/$fileName';
      /// Write audio data to the file
      await File(filePath).writeAsBytes(audioData);

    } else {
      throw Exception("Failed to fetch audio data: ${response.statusCode}");
    }
  }
}

class TextTranslator{
  static const BASE_URL = 'https://translation-api.ghananlp.org/v1/translate';
  final String apiKey;

  TextTranslator(this.apiKey);

  Future<String> translateText(String text, {String? targetLanguage}) async {
    final response = await http.post(
        Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json",
          "Cache-Control": "no-cache",
          "Ocp-Apim-Subscription-Key": apiKey
        },
        body: jsonEncode({
          "in": text,
          "lang": "en-tw"
        })
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      return response.statusCode.toString();
    }
  }
}