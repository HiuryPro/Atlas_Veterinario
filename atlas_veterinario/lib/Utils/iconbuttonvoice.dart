import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter/material.dart';

class IconButtonVoice extends StatefulWidget {
  final String fala;
  final Color cor;
  const IconButtonVoice({super.key, required this.cor, required this.fala});

  @override
  IconButtonVoiceState createState() => IconButtonVoiceState();
}

class IconButtonVoiceState extends State<IconButtonVoice> {
  bool isAtivo = false;
  Utils util = Utils();

  @override
  void initState() {
    super.initState();
    isAtivo = false;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isAtivo ? Icons.voice_over_off : Icons.record_voice_over),
      onPressed: () async {
        print(isAtivo);
        setState(() {
          isAtivo = !isAtivo;
        });

        await util.falar(widget.fala, isAtivo);

        if (mounted) {
          setState(() {
            isAtivo = false;
          });
        }
      },
      color: widget.cor, // Customize the icon color based on the state.
    );
  }
}
