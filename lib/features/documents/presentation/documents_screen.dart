import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Documents Screen
///
/// Displays a list of documents grouped by month
class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchVisible = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with Search Button
                      _buildTitleSection(context, isDark),

                      const SizedBox(height: 37),

                      // Search Field (if visible)
                      if (_isSearchVisible) ...[
                        _buildSearchField(context, isDark),
                        const SizedBox(height: 16),
                      ],

                      // Documents List
                      ..._buildDocumentsList(context, isDark),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation (stays in background when keyboard is visible)
              Builder(
                builder: (context) {
                  final isKeyboardVisible =
                      MediaQuery.of(context).viewInsets.bottom > 0;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isKeyboardVisible ? 0 : 1,
                    child: isKeyboardVisible
                        ? const SizedBox.shrink()
                        : const AppBottomNavigation(activeRoute: '/more'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // WCAG 2.2: Semantics für Zurück-Button
          Semantics(
            button: true,
            label: 'Zurück',
            child: Tooltip(
              message: 'Zurück',
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.go('/more'),
                child: SizedBox(
                  width: 48, // WCAG 2.5: Minimum Touch Target
                  height: 48,
                  child: Center(
                    child: Icon(
                      M3Icons.arrowBack,
                      color: textColor,
                      size: 24,
                      semanticLabel: 'Zurück',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance the search button width
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Expanded(
          child: Text(
            'Documents',
            style: GoogleFonts.openSans(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: textColor,
              height: 1.25,
            ),
          ),
        ),
        // Search Button - WCAG 2.2
        Semantics(
          button: true,
          label: 'Suchen',
          child: Tooltip(
            message: 'Suchen',
            child: InkWell(
              onTap: _toggleSearch,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48, // WCAG 2.5: Minimum Touch Target
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColorSchemes.darkCardBackground
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.search_outlined,
                    color: textColor,
                    size: 24,
                    semanticLabel: 'Suchen',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final bgColor = isDark
        ? AppColorSchemes.darkCardBackground
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      height: 56,
      alignment: Alignment.center,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
        cursorColor: AppColorSchemes.primaryDarkYellow,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: 'Bank statements, Bank receipts',
          hintStyle: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColorSchemes.greysMidGrey,
          ),
          prefixIcon: const Icon(
            M3Icons.search,
            color: AppColorSchemes.greysMidGrey,
            size: 24,
          ),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close,
                    color: textColor,
                    size: 24,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                ),
        ),
      ),
    );
  }

  List<Widget> _buildDocumentsList(BuildContext context, bool isDark) {
    final allDocuments = _getDocuments();
    
    // Filter documents based on search query
    final documents = _filterDocuments(allDocuments);

    List<Widget> widgets = [];
    
    // Group documents by month
    final Map<String, List<DocumentItem>> groupedDocs = {};
    for (final doc in documents) {
      if (!groupedDocs.containsKey(doc.month)) {
        groupedDocs[doc.month] = [];
      }
      groupedDocs[doc.month]!.add(doc);
    }

    // Sort months (newest first)
    final sortedMonths = groupedDocs.keys.toList()
      ..sort((a, b) {
        // Simple date comparison - in real app, use proper date parsing
        return b.compareTo(a);
      });

    for (int i = 0; i < sortedMonths.length; i++) {
      final month = sortedMonths[i];
      final monthDocs = groupedDocs[month]!;

      // Month Header
      widgets.add(_buildMonthHeader(month, isDark));
      widgets.add(const SizedBox(height: 21));

      // Documents for this month
      for (int j = 0; j < monthDocs.length; j++) {
        widgets.add(InkWell(
          onTap: () => _openPdf(context),
          child: _buildDocumentItem(monthDocs[j], isDark),
        ));
        if (j < monthDocs.length - 1) {
          widgets.add(const SizedBox(height: 0)); // Items have built-in spacing
        }
      }

      // Spacing between month groups
      if (i < sortedMonths.length - 1) {
        widgets.add(const SizedBox(height: 19)); // Space before next month header
      }
    }

    widgets.add(const SizedBox(height: AppSpacing.md));

    return widgets;
  }

  Widget _buildMonthHeader(String month, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      height: 54,
      alignment: Alignment.centerLeft,
      child: Text(
        month,
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1.375,
        ),
      ),
    );
  }

  Widget _buildDocumentItem(DocumentItem document, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with notification badge
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 24,
                  color: textColor,
                ),
                if (document.hasNotification)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColorSchemes.primaryDarkYellow,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColorSchemes.darkBackground
                              : AppColorSchemes.lightBackground,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  document.title,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                // Date and Author
                Text(
                  '${document.date} | ${document.author}',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DocumentItem> _filterDocuments(List<DocumentItem> documents) {
    if (_searchQuery.trim().length < 3) {
      return documents;
    }
    final normalizedQuery = _searchQuery.toLowerCase();
    return documents.where((document) {
      final title = document.title.toLowerCase();
      final author = document.author.toLowerCase();
      final date = document.date.toLowerCase();
      return title.contains(normalizedQuery) ||
          author.contains(normalizedQuery) ||
          date.contains(normalizedQuery);
    }).toList();
  }

  Future<void> _openPdf(BuildContext context) async {
    try {
      final pdfBytes = await rootBundle.load('assets/img/Mobile_Policy.pdf');
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes.buffer.asUint8List(),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Öffnen der PDF: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  List<DocumentItem> _getDocuments() {
    return [
      DocumentItem(
        title: 'Bank statement february 2026',
        date: '27.02.2025',
        author: 'Reto Haldner',
        month: 'February 2026',
        hasNotification: true,
      ),
      DocumentItem(
        title: 'Account statement february 2026',
        date: '27.02.2025',
        author: 'Reto Haldner',
        month: 'February 2026',
        hasNotification: true,
      ),
      DocumentItem(
        title: 'Legal information interest rates',
        date: '27.02.2025',
        author: 'Reto Haldner',
        month: 'February 2026',
        hasNotification: false,
      ),
      DocumentItem(
        title: 'Bank statement january 2026',
        date: '17.01.2025',
        author: 'Reto Haldner',
        month: 'January 2026',
        hasNotification: false,
      ),
      DocumentItem(
        title: 'Account statement january 2026',
        date: '17.01.2025',
        author: 'Reto Haldner',
        month: 'January 2026',
        hasNotification: false,
      ),
      DocumentItem(
        title: 'Legal information interest rates',
        date: '17.01.2025',
        author: 'Reto Haldner',
        month: 'January 2026',
        hasNotification: false,
      ),
    ];
  }
}

class DocumentItem {
  final String title;
  final String date;
  final String author;
  final String month;
  final bool hasNotification;

  DocumentItem({
    required this.title,
    required this.date,
    required this.author,
    required this.month,
    this.hasNotification = false,
  });
}

