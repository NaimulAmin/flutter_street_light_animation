import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home:HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool islighton=true;
  // positions
  Offset initialPosition=const Offset(250, 0);
  Offset switchPosition=const Offset(350, 350);
  Offset containerPosition=const Offset(350, 350);
  Offset finalPosition=const Offset(350, 350);
  // positions
  double lightLength =0;
  @override
  void didChangeDependencies(){
    final size = MediaQuery.of(context).size;
    initialPosition = Offset(size.width*0.9, 0);
    containerPosition = Offset(size.width*0.9, size.height*0.4);
    finalPosition =Offset(size.width*0.9, size.height*.5-size.width*0.1);
    if (islighton){
      switchPosition=containerPosition;
    }else{
      switchPosition=finalPosition;
    }
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Stack(
        fit: StackFit.expand,
        children: [
          //the following container is about
          // lamp and the light
          Container(
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                // get the lamp from image asset
                AspectRatio(aspectRatio: 1,
                child: Image.asset('assets/lamp.png')
                  ,),
                // designing the light
                Positioned(
                    top: 80, right: 95,
                    child:ClipPath(
                      clipper:lightDesign() ,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height:lightLength,
                        //it will be the legth of the light,
                        width: 150,
                      ),
                    )
                )
              ],
            ),
          ),
          // wire design
          Wire(
          //define the postions
            initialPosition: initialPosition,
              toOffset: switchPosition,

          ),
          // draggable widget design
          AnimatedPositioned(
              duration: const Duration(microseconds: 0),
             top: switchPosition.dy-size.width*0.1/2,
             left: switchPosition.dx-size.width*0.1/2,
            child: Draggable(
              feedback: Container(
                height: size.height*0.1,
                width: size.width*.1,
                decoration: const BoxDecoration(
                  shape:BoxShape.circle,
                ),
              ),
              onDragEnd: (details){
                if(islighton){
                  islighton=!islighton;
                  lightLength=260;
                  switchPosition=containerPosition;
                }
                else{
                  islighton=!islighton;
                  lightLength=0;
                  switchPosition=containerPosition;
                }
              },
              onDragUpdate: (details){
              setState(() {
                switchPosition=details.localPosition;
              });

              },
              child: Container(
                height: size.height*.1,
                width: size.width*.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:Border.all(color:Colors.white,width:3),
                  color: Colors.amber,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}

class lightDesign extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path =Path();
    path.moveTo(size.width/2-20,0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width/2+25,0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip
      (covariant CustomClipper<Path> oldClipper)=>true;
}

// stateful wire class
class Wire extends StatefulWidget {
  final Offset toOffset;
  final Offset initialPosition;

  const Wire({Key? key,required this.toOffset,required this.initialPosition}) : super(key: key);

  @override
  State<Wire> createState() => _WireState();
}

class _WireState extends State<Wire> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(
        toOffset:widget.toOffset,
          initialPosition: widget.initialPosition,
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  Paint? _paint;
  final Offset initialPosition;
  final Offset toOffset;
  LinePainter({required this.toOffset,required this.initialPosition}){
    _paint =Paint()
        ..color=Colors.white
        ..strokeWidth=10;
  }
  @override
  void paint(Canvas canvas,Size size){
    canvas.drawLine(initialPosition, toOffset, _paint!);

  }
  @override
  bool shouldRepaint(LinePainter olfDelegate){
    return false;
  }
}

