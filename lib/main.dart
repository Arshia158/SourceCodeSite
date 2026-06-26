import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SourceCodeSiteApp());
}

class SourceCodeSiteApp extends StatelessWidget {
  const SourceCodeSiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سورس کد سایت',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'AppFont',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'AppFont',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.dark,
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const native = MethodChannel('source_code_site/native');

  final urlController = TextEditingController();
  final codeScroll = ScrollController();

  bool loading = false;
  String sourceCode = '';
  String currentUrl = '';
  String status = 'لینک سایت را وارد کن و دکمه دریافت سورس را بزن.';

  @override
  void dispose() {
    urlController.dispose();
    codeScroll.dispose();
    super.dispose();
  }

  String normalizeUrl(String value) {
    final text = value.trim();
    if (text.startsWith('http://') || text.startsWith('https://')) {
      return text;
    }
    return 'https://$text';
  }

  Future<String> decodeResponse(HttpClientResponse response) async {
    final bytes = <int>[];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }

    final contentType = response.headers.value(HttpHeaders.contentTypeHeader)?.toLowerCase() ?? '';
    try {
      if (contentType.contains('charset=iso-8859-1')) {
        return latin1.decode(bytes, allowInvalid: true);
      }
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      return latin1.decode(bytes, allowInvalid: true);
    }
  }

  Future<void> fetchSource() async {
    final input = urlController.text.trim();
    if (input.isEmpty) {
      showMessage('لینک سایت را وارد کن.');
      return;
    }

    final link = normalizeUrl(input);
    final uri = Uri.tryParse(link);
    if (uri == null || uri.host.isEmpty || uri.scheme.isEmpty) {
      showMessage('لینک وارد شده معتبر نیست.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
      sourceCode = '';
      currentUrl = link;
      status = 'در حال دریافت سورس سایت...';
    });

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 20));
      request.followRedirects = true;
      request.headers.set(HttpHeaders.userAgentHeader, 'Mozilla/5.0 SourceCodeSiteApp');
      request.headers.set(HttpHeaders.acceptHeader, 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');

      final response = await request.close().timeout(const Duration(seconds: 25));
      final text = await decodeResponse(response);

      if (!mounted) return;
      setState(() {
        sourceCode = text.trim().isEmpty ? 'سورس خالی دریافت شد.' : text;
        status = 'سورس دریافت شد. حالا می‌توانی کپی، ذخیره یا اشتراک‌گذاری کنی.';
      });

      await Future.delayed(const Duration(milliseconds: 100));
      if (codeScroll.hasClients) {
        codeScroll.jumpTo(0);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        status = 'دریافت سورس ناموفق بود. ممکن است سایت دسترسی مستقیم را بسته باشد.';
      });
      showMessage('خطا در دریافت سورس سایت.');
    } finally {
      client.close(force: true);
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  String fileName() {
    final uri = Uri.tryParse(currentUrl);
    var host = 'source';
    if (uri != null && uri.host.isNotEmpty) {
      host = uri.host.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    }
    return '${host}_${DateTime.now().millisecondsSinceEpoch}.html';
  }

  Future<void> copyCode() async {
    if (sourceCode.isEmpty) {
      showMessage('هنوز سورسی دریافت نشده.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: sourceCode));
    showMessage('کل کد کپی شد.');
  }

  Future<void> saveHtml() async {
    if (sourceCode.isEmpty) {
      showMessage('هنوز سورسی دریافت نشده.');
      return;
    }

    try {
      await native.invokeMethod('saveHtml', {
        'fileName': fileName(),
        'content': sourceCode,
      });
      showMessage('پنجره ذخیره فایل باز شد.');
    } catch (_) {
      showMessage('ذخیره فایل انجام نشد.');
    }
  }

  Future<void> shareHtml() async {
    if (sourceCode.isEmpty) {
      showMessage('هنوز سورسی دریافت نشده.');
      return;
    }

    try {
      await native.invokeMethod('shareHtml', {
        'fileName': fileName(),
        'content': sourceCode,
      });
    } catch (_) {
      showMessage('اشتراک‌گذاری انجام نشد.');
    }
  }

  void showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text, textAlign: TextAlign.right)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سورس کد سایت'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            inputPanel(dark),
            Expanded(child: editorPanel(dark)),
            buttonsPanel(),
          ],
        ),
      ),
    );
  }

  Widget inputPanel(bool dark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextField(
                    controller: urlController,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintText: 'https://example.com',
                      prefixIcon: const Icon(Icons.link_rounded),
                      filled: true,
                      fillColor: dark ? const Color(0xFF07111F) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onSubmitted: (_) => fetchSource(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: loading ? null : fetchSource,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(92, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('دریافت'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              status,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: dark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget editorPanel(bool dark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          editorHeader(),
          Expanded(
            child: sourceCode.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'سورس کد سایت اینجا مثل کد ادیتور نمایش داده می‌شود.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.70), fontSize: 15),
                      ),
                    ),
                  )
                : Scrollbar(
                    controller: codeScroll,
                    child: SingleChildScrollView(
                      controller: codeScroll,
                      padding: const EdgeInsets.all(14),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: SelectableText(
                          sourceCode,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12.5,
                            height: 1.45,
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget editorHeader() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: const Color(0xFF111827),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          dot(const Color(0xFFEF4444)),
          const SizedBox(width: 6),
          dot(const Color(0xFFF59E0B)),
          const SizedBox(width: 6),
          dot(const Color(0xFF22C55E)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              currentUrl.isEmpty ? 'source.html' : currentUrl,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dot(Color color) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget buttonsPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: copyCode,
              icon: const Icon(Icons.copy_rounded),
              label: const Text('کپی کد'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: saveHtml,
              icon: const Icon(Icons.save_alt_rounded),
              label: const Text('ذخیره'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.icon(
              onPressed: shareHtml,
              icon: const Icon(Icons.share_rounded),
              label: const Text('اشتراک'),
            ),
          ),
        ],
      ),
    );
  }
}
