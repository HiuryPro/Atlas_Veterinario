import 'package:flutter/material.dart';

class RowCentralizada extends StatefulWidget {
  final Widget componente;
  const RowCentralizada({super.key, required this.componente});

  @override
  State<RowCentralizada> createState() => _RowCentralizadaState();
}

class _RowCentralizadaState extends State<RowCentralizada> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(child: widget.componente),
        const Expanded(child: SizedBox())
      ],
    );
  }
}
