import 'package:flutter/material.dart';

class MyTimeSlider extends StatefulWidget {
  final Function(double) onChanged; // Add this line

  MyTimeSlider({required this.onChanged}); // Add this line

  @override
  _MyTimeSliderState createState() => _MyTimeSliderState();
}

class _MyTimeSliderState extends State<MyTimeSlider> {
  double _sliderValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _sliderValue.toInt().toString(),
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              ' min',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 2),
            )
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: RectangularSliderThumbShape(),

            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            thumbColor: Colors.white,
            activeTrackColor: _getTrackColor(),
            inactiveTrackColor: Color.fromARGB(137, 158, 158, 158),
            trackHeight: 7.0, // Increase the height of the track
          ),
          child: Slider(
            value: _sliderValue,
            min: 1,
            max: 35,
            divisions: 34,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
      ],
    );
  }

  Color _getTrackColor() {
    double t = (_sliderValue - 1) / (35 - 1);
    return Color.lerp(Colors.blue, Colors.purple, t)!;
  }
}

class RectangularSliderThumbShape extends SliderComponentShape {
  static const double _thumbHeight = 20.0; // Increased thumb height
  static const double _thumbWidth = 5.0; // Increased thumb width

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(_thumbWidth, _thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Rect rect = Rect.fromCenter(
      center: center,
      width: _thumbWidth,
      height: _thumbHeight,
    );
    context.canvas.drawRect(rect, paint);
  }
}
