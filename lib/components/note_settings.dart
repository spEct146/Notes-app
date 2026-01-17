import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteSettings extends StatelessWidget {
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;

  const NoteSettings({
    super.key,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onEditTap!();
          },
          child: Text(
            'Edit',
            style: GoogleFonts.crimsonText(
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onDeleteTap!();
          },
          child: Text(
            'Delete',
            style: GoogleFonts.crimsonText(
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ],
    );
  }
}
