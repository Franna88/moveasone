import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WatchButton extends StatefulWidget {
  final String userId;
  final bool isWatched;

  const WatchButton({
    super.key,
    required this.userId,
    required this.isWatched,
  });

  @override
  State<WatchButton> createState() => _WatchButtonState();
}

class _WatchButtonState extends State<WatchButton> {
  bool _isWatched = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _isWatched = widget.isWatched;
  }

  @override
  void didUpdateWidget(WatchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isWatched != widget.isWatched) {
      setState(() {
        _isWatched = widget.isWatched;
      });
    }
  }

  Future<void> _toggleWatchStatus() async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);

      if (_isWatched) {
        // Remove from watch list
        await docRef.update({
          'isWatched': false,
          'watchReason': FieldValue.delete(),
          'watchedSince': FieldValue.delete(),
        });
      } else {
        // Add to watch list
        await docRef.update({
          'isWatched': true,
          'watchReason': 'Manually added to watch list',
          'watchedSince': FieldValue.serverTimestamp(),
        });
      }

      setState(() {
        _isWatched = !_isWatched;
        _isUpdating = false;
      });

      // Show feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isWatched
              ? 'User added to watch list'
              : 'User removed from watch list'),
          duration: const Duration(seconds: 2),
          backgroundColor: _isWatched ? Colors.green : Colors.blue,
        ),
      );
    } catch (e) {
      print('Error updating watch status: $e');

      // Reset to original state on error
      setState(() {
        _isWatched = widget.isWatched;
        _isUpdating = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine button appearance based on watch status
    final Color buttonColor =
        _isWatched ? Color(0xFFF39C12) : Colors.grey.shade400;
    final String tooltipText =
        _isWatched ? 'Remove from watch list' : 'Add to watch list';

    return Tooltip(
      message: tooltipText,
      child: InkWell(
        onTap: _toggleWatchStatus,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: buttonColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: _isUpdating
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                  ),
                )
              : Icon(
                  _isWatched ? Icons.visibility : Icons.visibility_outlined,
                  color: buttonColor,
                  size: 20,
                ),
        ),
      ),
    );
  }
}
