import 'package:flutter/material.dart';

class RoundedRectangleTabIndicator extends Decoration {
  late final BoxPainter _painter;

  RoundedRectangleTabIndicator(
    {required Color color, required double weight, required double width})
    : _painter = _RRectanglePainterColor(color, weight, width); 
  
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;


}

class _RRectanglePainterColor extends BoxPainter{
  late final Paint _paint;
  late final double weight;
  late final double width;

  _RRectanglePainterColor(Color color, this.weight, this.width)
    : _paint =Paint()
    ..color = color
    ..isAntiAlias = true;
    
      @override
      void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
      // TODO: implement paint
        final Offset customOffset = offset + Offset(0, cfg.size!.height - weight);
        
        //Custom Rectangle
        Rect myRect = customOffset & Size(width, weight);

        // Custom Rounded Rectangle
        RRect myRRect = RRect.fromRectXY(myRect, weight, weight);

        canvas.drawRRect(myRRect, _paint);
      }


}