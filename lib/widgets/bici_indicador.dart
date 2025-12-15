import 'package:flutter/material.dart';

class BikeQuantityIndicator extends StatelessWidget {
  final int quantity;
  final bool isElectric;

  const BikeQuantityIndicator({
    super.key,
    required this.quantity,
    this.isElectric = false,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor;

    if (isElectric) {
      circleColor = Colors.blue; 
    } else {
      if (quantity < 5) {
        circleColor = Colors.red;
      } else if (quantity < 10) {
        circleColor = Colors.amber;
      } else {
        circleColor = Colors.green;
      }
    }

    return Column(
      children: [
        Icon(
          isElectric ? Icons.electric_bike : Icons.pedal_bike, 
          color: Colors.black87,
          size: 24,
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(blurRadius: 2, color: Colors.black26, offset: Offset(0, 2))
            ]
          ),
          child: Center(
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}