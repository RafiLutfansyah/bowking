import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime expiresAt;

  const CountdownTimer({
    super.key,
    required this.expiresAt,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration? _timeRemaining;
  String _formattedTime = '';

  @override
  void initState() {
    super.initState();
    _updateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateTimeRemaining();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    final Duration? newTimeRemaining;
    
    if (widget.expiresAt.isAfter(now)) {
      newTimeRemaining = widget.expiresAt.difference(now);
    } else {
      newTimeRemaining = null;
      // Stop timer when expired to prevent wasted CPU cycles
      _timer?.cancel();
      _timer = null;
    }
    
    // Only call setState if the formatted string actually changes
    final newFormattedTime = _formatDurationValue(newTimeRemaining);
    if (_formattedTime != newFormattedTime) {
      setState(() {
        _timeRemaining = newTimeRemaining;
        _formattedTime = newFormattedTime;
      });
    }
  }

  Color _getColor() {
    if (_timeRemaining == null) return AppColors.textTertiary;
    if (_timeRemaining!.inHours >= 24) return AppColors.success;
    if (_timeRemaining!.inHours >= 1) return AppColors.warning;
    return AppColors.error;
  }

  String _formatDurationValue(Duration? duration) {
    if (duration == null) return 'Expired';
    
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else {
      return '${minutes}m ${seconds}s';
    }
  }

  String _formatDuration() {
    return _formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(),
      style: TextStyle(
        color: _getColor(),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
