import 'package:flutter/material.dart';

class TreePage extends StatelessWidget {
  final String fatherName;
  final String motherName;
  final List<Map<String, dynamic>> children;

  TreePage({required this.fatherName, required this.motherName, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Tree'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildParentBox(fatherName, Colors.blue, 'Dad'),
                  SizedBox(width: 16),
                  _buildParentBox(motherName, Colors.pink, 'Mom'),
                ],
              ),
              SizedBox(height: 8),
              CustomPaint(
                size: Size(200, 50),
                painter: LinePainter(),
              ),
              if (children.isNotEmpty)
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: children.map((child) {
                    return _buildChildBox(
                      child['name'],
                      child['birthDate'],
                      Colors.green,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParentBox(String name, Color color, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildChildBox(String name, DateTime birthDate, Color color) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            '${birthDate.year}-${birthDate.month}-${birthDate.day}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw lines from parents to children
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(size.width * 0.75, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.25, size.height / 2), Offset(size.width * 0.75, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
