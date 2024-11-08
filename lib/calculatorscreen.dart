import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';



class Calculatorscreen extends StatefulWidget {
  const Calculatorscreen({super.key});

  @override
  State<Calculatorscreen> createState() => _CalculatorscreenState();
}

class _CalculatorscreenState extends State<Calculatorscreen> {
  String num1 ='';//contains first number
  String operand ='';//contains arithmetic operations
  String num2 ='';//contains second number

  @override
  Widget build(BuildContext context) {
    final screenSized = MediaQuery.of(context).size;
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '$num1$operand$num2'.isEmpty? '0':'$num1$operand$num2',
                      style: const TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues.map(
                  (values) => SizedBox(
                    width:screenSized.width/4,
                      height: screenSized.width/4,
                      child: buildbutton(values)
                  )
              ).toList()
            )
          ],
        ),
      ),
    );
  }
  //buttons editor
   buildbutton(values){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color:[Btn.equ].contains(values)?Colors.green:
        Colors.black12,
        clipBehavior: Clip.hardEdge,
        shape:OutlineInputBorder(
          borderRadius: BorderRadius.circular(150),
            borderSide: const BorderSide(color: Colors.black12)
        ),
        child: InkWell(
            onTap:()=> onBtnTap(values),
          child: Center(
              child: Text(
                values,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                      fontSize:30.0,
                  color: getBtnColor(values)
                ),
              )
          ),
        ),
      ),
    );
  }
  //Operation section
  void onBtnTap(String values){
    if(values == Btn.del){
      delete(values);
      return;
    }
    if(values == Btn.clr){
      ClearAll(values);
      return;
    }
    if(values == Btn.per){
      convertToPercent(values);
      return;
    }
    if (values == Btn.equ){
      operation(values);
      return;
    }
   arithmetics(values);
  }

  //where calculations take place
  void operation(values){
    if(num1.isEmpty)return;
    if(operand.isEmpty)return;
    if(num2.isEmpty)return;

    final double fnum = double.parse(num1);
    final double snum = double.parse(num2);

    var result = 0.0;

    switch(operand){
      case Btn.add :
       result= fnum + snum;
       break;
      case Btn.sub :
        result= fnum - snum;
        break;
      case Btn.div :
        result= fnum / snum;
        break;
      case Btn.mul :
        result= fnum * snum;
        break;
        default:

    }
    setState(() {
      num1 = '$result';
      if(num1.endsWith('.0')){
        num1 = num1.substring(0,num1.length-2);
      }
      operand = '';
      num2 = '';
    });



  }

  //Percentage Conversion
  void convertToPercent(values){
  if(num1.isNotEmpty&&operand.isNotEmpty&&num2.isNotEmpty){
    ///calculate before convert
    operation(values);
  }if(operand.isNotEmpty){
    //cannot converts
    return;
  }
  final number = double.parse(num1);
  setState(() {
    num1 = '${(number/100)}';
    num2 = '';
    operand = '';
  });

  }
//Clear all values
  void ClearAll(values){
    setState(() {
      num1 ='';
      operand ='';
      num2 ='';
    });
  }

  //delete the values one by one
  void delete(values){
    if(num2.isNotEmpty){
      num2 = num2.substring(0,num2.length-1);
    }else if(operand.isNotEmpty){
      operand = '';
    } else if(num1.isNotEmpty){
      num1 = num1.substring(0,num1.length-1);
    }
    setState(() {});


  }

//Setting the values and arithmetic operation
  void arithmetics(values){
    //check if operand is not '.'
    if(values!=Btn.dot&&int.tryParse(values)==null){
      if(operand.isNotEmpty&&num2.isNotEmpty){
        //Calculation take place
        operation(values);
      }
      operand = values;
      //Assigning value to num1
    }else if(num1.isEmpty||operand.isEmpty){
      if(values==Btn.dot&&num1.contains(Btn.dot))return;
      if(values==Btn.dot&&(num1.isEmpty||num1==Btn.dot)){
        values= '0.';
      }
      num1+=values;
    }
    //Assigning value to num2
    else if(num2.isEmpty||operand.isNotEmpty) {
      if (values == Btn.dot && num2.contains(Btn.dot)) return;
      if (values == Btn.dot && (num2.isEmpty || num2 == Btn.dot)) {
        values = '0.';
      }
      num2+=values;
    }
    setState(() {});
  }

  //Buttons Color
  Color getBtnColor(values){
    return  [Btn.del,Btn.clr].contains(values)?Colors.redAccent:
    [Btn.brac,
    Btn.add,Btn.sub,
    Btn.div,Btn.per,Btn.mul].contains(values)?Colors.green:
    Colors.white;
  }
}
