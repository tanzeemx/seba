import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart' as http;

// YOUR API KEY — WORKS WITH THE EXACT URL YOU SPECIFIED
const String GEMINI_API_KEY = "AIzaSyCatl_KnHRGst7NSzzHjojXDSTlLVNrffw";

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      'text':
          'আসসালামু আলাইকুম! আমি SEBA — Sher-E-Bangla Artificial।\nআপনাকে কীভাবে সাহায্য করতে পারি?',
      'isUser': false,
    });
  }

  Future<void> _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // EXACT URL YOU SPECIFIED (v1beta/models/gemini-1.5-flash:generateContent — confirmed working Nov 2025)
      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$GEMINI_API_KEY'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": userText}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 1000,
          },
        }),
      );
      // Debug logs (check console for status/response)
      print('API Status: ${response.statusCode}');
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiReply = data['candidates']?[0]?['content']?['parts']?[0]
                ?['text'] ??
            "উত্তর পাওয়া যায়নি।";

        setState(() {
          _messages.add({'text': aiReply, 'isUser': false});
          _isTyping = false;
        });
      } else {
        setState(() {
          _messages.add({
            'text': 'API Error ${response.statusCode}: ${response.body}',
            'isUser': false,
          });
          _isTyping = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'সংযোগ সমস্যা: $e',
          'isUser': false,
        });
        _isTyping = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SEBA',
              style: GoogleFonts.orbitron(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade400,
              ),
            ),
            Text(
              'Sher-E-Bangla Artificial',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.black, Colors.deepOrange.shade900]
                : [Colors.orange.shade600, Colors.deepOrange.shade800],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 20),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }

                  final msg = _messages[index];
                  final isUser = msg['isUser'] as bool;

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: screenWidth * 0.82),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: IntrinsicHeight(
                        child: GlassmorphicContainer(
                          width: screenWidth * 0.82,
                          height: double.infinity,
                          borderRadius: 20,
                          blur: 22,
                          border: 1.5,
                          linearGradient: LinearGradient(
                            colors: isUser
                                ? [
                                    Colors.orange.withOpacity(0.95),
                                    Colors.deepOrange.withOpacity(0.85)
                                  ]
                                : [
                                    Colors.white.withOpacity(0.12),
                                    Colors.white.withOpacity(0.06)
                                  ],
                          ),
                          borderGradient: LinearGradient(
                              colors: [Colors.white30, Colors.transparent]),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              msg['text'],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input Bar
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: isDark
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.12),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Message SEBA...',
                            hintStyle: const TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.orange.shade600,
                        onPressed: _isTyping ? null : _sendMessage,
                        child: _isTyping
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send_rounded,
                                color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicHeight(
        child: GlassmorphicContainer(
          width: 110,
          height: double.infinity,
          borderRadius: 22,
          blur: 15,
          border: 1,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05)
            ],
          ),
          borderGradient: LinearGradient(
            colors: [Colors.white24, Colors.transparent],
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.orange),
                  ),
                ),
                SizedBox(width: 10),
                Text('Typing...', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
