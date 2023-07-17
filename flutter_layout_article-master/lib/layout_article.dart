import 'package:flutter/material.dart';
import 'package:flutter_layout_article/button.dart';
import 'package:flutter_layout_article/examples.dart';

//////////////////////////////////////////////////

class FlutterLayoutArticle extends StatefulWidget {
  final List<Example> examples;

  FlutterLayoutArticle(this.examples);

  @override
  _FlutterLayoutArticleState createState() => _FlutterLayoutArticleState();
}

//////////////////////////////////////////////////

class _FlutterLayoutArticleState extends State<FlutterLayoutArticle> {
  late int count;
  late String code;
  late String explanation;

  @override
  void initState() {
    count = 1;
    code = Example1().code;
    explanation = Example1().explanation;
    super.initState();
  }

  @override
  void didUpdateWidget(FlutterLayoutArticle oldWidget) {
    super.didUpdateWidget(oldWidget);
    var example = widget.examples[count - 1];
    code = example.code;
    explanation = example.explanation;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Layout Article',
      home: SafeArea(
        child: Material(
          color: Colors.black,
          child: Container(
            // width: 300,
            // height: 600,
            // color: Color(0xFFCCCCCC),
            child: Column(
              children: [
                Expanded(
                  child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: double.infinity, height: double.infinity),
                      child: widget.examples[count - 1]),
                ),
                Container(
                  height: 50,
                  //  width: double.infinity,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < widget.examples.length; i++)
                          Container(
                            width: 60,
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: button(i + 1),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        //key: ValueKey(count),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Center(child: Text(code)),
                              SizedBox(height: 15),
                              Text(
                                explanation,
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    height: 270,
                    color: Colors.grey[200]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget button(int exampleNumber) => Button(
        //key: ValueKey("button$exampleNumber"),
        isSelected: this.count == exampleNumber,
        exampleNumber: exampleNumber,
        onPressed: () {
          showExample(
            exampleNumber,
            widget.examples[exampleNumber - 1].code,
            widget.examples[exampleNumber - 1].explanation,
          );
        },
      );

  void showExample(int exampleNumber, String code, String explanation) =>
      setState(() {
        this.count = exampleNumber;
        this.code = code;
        this.explanation = explanation;
      });
}
