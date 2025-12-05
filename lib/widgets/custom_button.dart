import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const CustomButton({
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 68,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE0F4F5) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
          border: isSelected
              ? Border.all(color: Color(0xFFA7DCE5), width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D3A4A),
            ),
          ),
        ),
      ),
    );
  }
}
