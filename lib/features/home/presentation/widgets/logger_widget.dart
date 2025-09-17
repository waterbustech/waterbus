import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/presentation/bloc/logger/logger_bloc.dart';

class LoggerWidget extends StatefulWidget {
  const LoggerWidget({super.key});

  @override
  State<LoggerWidget> createState() => LoggerWidgetState();
}

class LoggerWidgetState extends State<LoggerWidget> {
  final ScrollController _controller = ScrollController();

  static const double _minExtent = 0.1;
  static const double _midExtent = 0.5;
  static const double _maxExtent = 0.9;

  double _extent = _midExtent;
  int? _selectedLogIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: MediaQuery.of(context).size.height * _extent,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildResizeHandle(),
            _buildHeader(),
            Expanded(
              child: _LocalNavigator(
                child: _LogBody(
                  scrollController: _controller,
                  selectedLogIndex: _selectedLogIndex,
                  onLogSelected: (index) {
                    setState(() {
                      _selectedLogIndex =
                          _selectedLogIndex == index ? null : index;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResizeHandle() {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeUpDown,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            _extent = _extent < _maxExtent ? _maxExtent : _midExtent;
          });
        },
        onVerticalDragUpdate: (details) {
          final double height = MediaQuery.of(context).size.height;
          final double delta = details.delta.dy / height;

          setState(() {
            _extent = (_extent - delta).clamp(_minExtent, _maxExtent);
          });
        },
        child: Container(
          height: 8,
          width: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.terminal,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            "Console",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          BlocSelector<LoggerBloc, LoggerState, int>(
            selector: (state) {
              return state.records.length;
            },
            builder: (context, logsLength) {
              return Text(
                "$logsLength logs",
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LogBody extends StatefulWidget {
  final ScrollController scrollController;
  final int? selectedLogIndex;
  final Function(int) onLogSelected;

  const _LogBody({
    required this.scrollController,
    required this.selectedLogIndex,
    required this.onLogSelected,
  });

  @override
  State<_LogBody> createState() => _LogBodyState();
}

class _LogBodyState extends State<_LogBody> {
  final TextEditingController _filterController = TextEditingController();
  Timer? _debounce;
  Level? _level;

  @override
  void initState() {
    super.initState();
    _filterController.text = AppBloc.loggerBloc.keyword;
    _level = AppBloc.loggerBloc.level;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _filterController.dispose();
    super.dispose();
  }

  Color _getLevelColor(Level level) {
    switch (level.name.toUpperCase()) {
      case 'SEVERE':
      case 'ERROR':
        return const Color(0xFFEF4444);
      case 'WARNING':
      case 'WARN':
        return const Color(0xFFF59E0B);
      case 'INFO':
        return const Color(0xFF3B82F6);
      case 'CONFIG':
        return const Color(0xFF8B5CF6);
      case 'FINE':
      case 'FINER':
      case 'FINEST':
      case 'DEBUG':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  String _getLevelIcon(Level level) {
    switch (level.name.toUpperCase()) {
      case 'SEVERE':
      case 'ERROR':
        return '✗';
      case 'WARNING':
      case 'WARN':
        return '⚠';
      case 'INFO':
        return 'ℹ';
      case 'CONFIG':
        return '⚙';
      case 'FINE':
      case 'FINER':
      case 'FINEST':
      case 'DEBUG':
        return '●';
      default:
        return '○';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: BlocBuilder<LoggerBloc, LoggerState>(
            builder: (context, state) {
              if (state.records.isEmpty) {
                return _buildEmptyState();
              }

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: ListView.builder(
                  reverse: true,
                  controller: widget.scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: state.records.length,
                  itemBuilder: (context, index) {
                    final records = state.records.reversed.toList();
                    final record = records[index];
                    final isSelected = widget.selectedLogIndex == index;

                    return _LogItem(
                      record: record,
                      index: index,
                      isSelected: isSelected,
                      levelColor: _getLevelColor(record.level),
                      levelIcon: _getLevelIcon(record.level),
                      onTap: () => widget.onLogSelected(index),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: _filterController,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  hintText: 'Filter logs...',
                  hintStyle: TextStyle(
                    fontFamily: 'monospace',
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    size: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                ),
                onChanged: (val) {
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(
                    const Duration(milliseconds: 300),
                    () {
                      AppBloc.loggerBloc.add(LoggerFilterEvent(keyword: val));
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildLevelFilter(),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: LucideIcons.trash2,
            tooltip: 'Clear logs',
            onTap: () {
              AppBloc.loggerBloc.add(LoggerClearEvent());
              widget.onLogSelected(-1); // Clear selection
            },
          ),
          const SizedBox(width: 4),
          _buildActionButton(
            icon: LucideIcons.download,
            tooltip: 'Export logs',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLevelFilter() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Level?>(
          value: _level,
          hint: Text(
            'Level',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          icon: Icon(
            LucideIcons.chevronDown,
            size: 14,
          ),
          onChanged: (val) {
            setState(() {
              _level = _level == val ? null : val;
            });
            AppBloc.loggerBloc.add(
              LoggerFilterEvent(
                keyword: _filterController.text,
                level: _level,
              ),
            );
          },
          items: [
            DropdownMenuItem<Level?>(
              child: Text(
                'All levels',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            ...Level.LEVELS.map(
              (level) => DropdownMenuItem<Level>(
                value: level,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getLevelIcon(level),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getLevelColor(level),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      level.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.terminal,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No logs available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Logs will appear here as they are generated',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final LogRecord record;
  final int index;
  final bool isSelected;
  final Color levelColor;
  final String levelIcon;
  final VoidCallback onTap;

  const _LogItem({
    required this.record,
    required this.index,
    required this.isSelected,
    required this.levelColor,
    required this.levelIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        final message = _getLogMessage(record);
        Clipboard.setData(ClipboardData(text: message));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Log copied to clipboard'),
            duration: const Duration(seconds: 2),
            backgroundColor: levelColor,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected
              ? levelColor.withValues(alpha: .1)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? levelColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: .3),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 16,
                alignment: Alignment.center,
                child: Text(
                  levelIcon,
                  style: TextStyle(
                    fontSize: 10,
                    color: levelColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Text(
                  record.level.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: levelColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: Text(
                  _formatTime(_getLogTime(record)),
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SelectableText(
                  _getLogMessage(record),
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  String _getLogMessage(LogRecord record) {
    return '[${record.loggerName}] ${record.message}';
  }

  DateTime _getLogTime(LogRecord record) {
    return record.time;
  }
}

class _LocalNavigator extends StatelessWidget {
  final Widget child;
  const _LocalNavigator({required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => child,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        opaque: false,
      ),
    );
  }
}
