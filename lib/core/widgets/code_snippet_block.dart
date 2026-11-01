import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Interactive syntax-highlighted code block with line numbers, copy-to-clipboard,
/// and optional active line highlighting for educational stepping.
class CodeSnippetBlock extends StatefulWidget {
  final String code;
  final String? title;
  final int? activeLineIndex;
  final double scale;

  const CodeSnippetBlock({
    super.key,
    required this.code,
    this.title,
    this.activeLineIndex,
    this.scale = 1.0,
  });

  @override
  State<CodeSnippetBlock> createState() => _CodeSnippetBlockState();
}

class _CodeSnippetBlockState extends State<CodeSnippetBlock> {
  bool _copied = false;

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (mounted) {
      setState(() => _copied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código copiado al portapapeles'),
          duration: Duration(seconds: 1),
          backgroundColor: AppColors.secondaryCyan,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _copied = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.code.split('\n');
    final scale = widget.scale;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF100C1E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.surfaceBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Window dots
                Row(
                  children: [
                    _windowDot(const Color(0xFFFF5F56)),
                    const SizedBox(width: 6),
                    _windowDot(const Color(0xFFFFBD2E)),
                    const SizedBox(width: 6),
                    _windowDot(const Color(0xFF27C93F)),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title ?? 'Dart',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: _copyToClipboard,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _copied ? Icons.check_rounded : Icons.copy_rounded,
                          size: 14 * scale,
                          color: _copied
                              ? AppColors.successGreen
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _copied ? 'Copiado' : 'Copiar',
                          style: TextStyle(
                            color: _copied
                                ? AppColors.successGreen
                                : AppColors.textSecondary,
                            fontSize: 11 * scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Code lines with numbers and highlighting
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(lines.length, (index) {
                final line = lines[index];
                final isLineActive = widget.activeLineIndex == index;

                return Container(
                  color: isLineActive
                      ? AppColors.secondaryCyan.withValues(alpha: 0.12)
                      : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Line number
                      SizedBox(
                        width: 28,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: isLineActive
                                ? AppColors.secondaryCyan
                                : AppColors.textMuted.withValues(alpha: 0.6),
                            fontSize: 13 * scale,
                            fontWeight: isLineActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Syntax highlighted line content
                      Expanded(
                        child: SelectableText.rich(
                          _highlightLine(line, scale),
                          style: AppTypography.code(scale),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _windowDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  TextSpan _highlightLine(String line, double scale) {
    if (line.trim().startsWith('//')) {
      return TextSpan(
        text: line,
        style: TextStyle(
          color: AppColors.codeComment,
          fontStyle: FontStyle.italic,
          fontSize: 13.5 * scale,
        ),
      );
    }

    final spans = <TextSpan>[];
    final pattern = RegExp(
      r'(\/\/[^\n]*)|("[^"\\]*(?:\\.[^"\\]*)*"|'
      r"'[^'\\]*(?:\\.[^'\\]*)*')|"
      r'\b(var|final|const|int|double|String|bool|void|true|false|null|if|else|while|for|return|print)\b|'
      r'(\b\d+(\.\d+)?\b)|'
      r'([a-zA-Z_][a-zA-Z0-9_]*)|'
      r'([^\s\w])',
    );

    int lastMatchEnd = 0;
    for (final match in pattern.allMatches(line)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: line.substring(lastMatchEnd, match.start),
            style: TextStyle(color: AppColors.textPrimary),
          ),
        );
      }

      final text = match.group(0)!;

      if (match.group(1) != null) {
        // Comment
        spans.add(
          TextSpan(
            text: text,
            style: TextStyle(
              color: AppColors.codeComment,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      } else if (match.group(2) != null) {
        // String
        spans.add(
          TextSpan(
            text: text,
            style: const TextStyle(
              color: AppColors.codeString,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else if (match.group(3) != null) {
        // Keyword
        spans.add(
          TextSpan(
            text: text,
            style: const TextStyle(
              color: AppColors.codeKeyword,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (match.group(4) != null) {
        // Number
        spans.add(
          TextSpan(
            text: text,
            style: const TextStyle(
              color: AppColors.codeNumber,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else if (match.group(7) != null) {
        // Symbols / Operators
        spans.add(
          TextSpan(
            text: text,
            style: TextStyle(
              color: AppColors.secondaryCyan.withValues(alpha: 0.9),
            ),
          ),
        );
      } else {
        // Identifiers
        spans.add(
          TextSpan(
            text: text,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        );
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < line.length) {
      spans.add(
        TextSpan(
          text: line.substring(lastMatchEnd),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
