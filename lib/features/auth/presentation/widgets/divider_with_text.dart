import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    const Color lineColor = Color(0xFFCACACA);

    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: lineColor,
            thickness:
                1, // Ketebalan garis agar terlihat tegas seperti di gambar
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ), // Jarak sedikit lebih lebar
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black, // Teks warna hitam sesuai permintaan
              fontSize: 16, // Ukuran sedikit lebih besar agar proporsional
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: lineColor, thickness: 1)),
      ],
    );
  }
}
