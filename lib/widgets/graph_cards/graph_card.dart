import 'package:flutter/material.dart';

class GraphCard extends StatefulWidget {
  const GraphCard({
    super.key,
    required this.graph,
    required this.title,
    this.gapheight = 0,
    this.height = 520,
    this.legend = const SizedBox(),
  });

  final String title;
  final Widget graph;
  final double height;
  final Widget legend;
  final double gapheight;

  @override
  State<GraphCard> createState() => _GraphCardState();
}

class _GraphCardState extends State<GraphCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 43, 43, 43),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45),
      ),
      child: SizedBox(
        height: widget.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.title,
                    style: const TextStyle(fontSize: 24, color: Colors.white)),
              ),
              const SizedBox(
                height: 30,
              ),
              widget.graph,
              SizedBox(height: widget.gapheight),
              widget.legend,
            ],
          ),
        ),
      ),
    );
  }
}
