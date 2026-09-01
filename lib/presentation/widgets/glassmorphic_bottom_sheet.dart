import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Glassmorphic bottom sheet with backdrop blur effect
class GlassmorphicBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final VoidCallback? onDismiss;
  
  const GlassmorphicBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.onDismiss,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark 
          ? const Color(0xFF1A1A2E).withOpacity(0.95)
          : const Color(0xFFFFFFFF).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark 
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (onDismiss != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onDismiss,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          
          // Content
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
          
          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// Bottom sheet for verse actions
void showVerseActionsBottomSheet(
  BuildContext context, {
  required String verseText,
  required String reference,
  VoidCallback? onCopy,
  VoidCallback? onHighlight,
  VoidCallback? onNote,
  VoidCallback? onShare,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => GlassmorphicBottomSheet(
      title: 'Verse Actions',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Verse preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reference,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  verseText.length > 100 
                    ? '${verseText.substring(0, 100)}...'
                    : verseText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Crimson_Text',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Action buttons
          _ActionTile(
            icon: Icons.copy_rounded,
            label: 'Copy',
            onTap: () {
              HapticFeedback.lightImpact();
              onCopy?.call();
              Navigator.pop(context);
            },
          ),
          _ActionTile(
            icon: Icons.format_color_fill_rounded,
            label: 'Highlight',
            onTap: () {
              HapticFeedback.lightImpact();
              onHighlight?.call();
              Navigator.pop(context);
            },
          ),
          _ActionTile(
            icon: Icons.note_add_rounded,
            label: 'Add Note',
            onTap: () {
              HapticFeedback.lightImpact();
              onNote?.call();
              Navigator.pop(context);
            },
          ),
          _ActionTile(
            icon: Icons.share_rounded,
            label: 'Share',
            onTap: () {
              HapticFeedback.lightImpact();
              onShare?.call();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
