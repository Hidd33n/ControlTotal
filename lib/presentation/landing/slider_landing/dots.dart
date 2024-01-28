import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  Dots({required this.currentPage, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => buildDot(index),
      ),
    );
  }

  Widget buildDot(int index) {
    bool isCurrentPage = index == currentPage;
    return Container(
      width: isCurrentPage ? 12 : 8,
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentPage ? Colors.blue : Colors.grey,
      ),
    );
  }
}
