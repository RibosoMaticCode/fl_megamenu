import 'package:fl_megamenu/category_menu_model.dart';
import 'package:fl_megamenu/provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final PlatanitosNodeProvider apiPlatanitosNode = PlatanitosNodeProvider();
  List<CategoryMenuModel> listCategory = [];

  @override
  void initState() {
    super.initState();

    apiPlatanitosNode.getCategoriesMenuList().then((response) {
      listCategory = response!;
    });
  }

  List<bool> isVisible = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[megaMenu(listCategory)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget megaMenu(listCategory) {
    // Listado izquierda
    List<Widget> categoriesCol = [];
    List bloques = [];

    listCategory!.asMap().forEach((index, value) {
      // Columna izquierda
      categoriesCol.add(Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 1.0)),
          alignment: Alignment.centerLeft,
          child: MouseRegion(
              onEnter: (event) {
                setState(() {
                  isVisible.fillRange(0, isVisible.length, false);
                  isVisible[index] = true;
                });
              },
              child: Text('${value.description}'))));

      // Panel derecho
      Map<String, dynamic> listCategoryNivel2 = value.children;
      List subBloques = [];

      listCategoryNivel2.forEach((index, value) {
        subBloques.add(value);
      });

      bloques.add(subBloques);
    });

    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
      child: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            lg: 3,
            child: Column(children: categoriesCol),
          ),
          ResponsiveGridCol(lg: 9, child: bloqueWidgets(bloques))
        ],
      ),
    );
  }

  // Devuelve las subcatogiras en bloque organizados
  List subcategoriesInPanel(List dataBloques) {
    int maxItemsCol = 14;
    List paneles = [];

    // for (var dataBloque in dataBloques) {
    for (var j = 0; j < dataBloques.length; j++) {
      List dataBloque = dataBloques[j];
      List panel = [];
      int sum = 0;
      int acum = 0;

      List hijos = [];

      // bucle
      for (var i = 0; i < dataBloque.length; i++) {
        // item - titulo

        hijos.add('${dataBloque[i]['description']}*');

        // items hijos
        if (dataBloque[i]['children'].length > 0 &&
            dataBloque[i]['children'] != null) {
          Map<String, dynamic> listCategoryNivel3 = dataBloque[i]['children'];

          listCategoryNivel3.forEach((index, value) {
            hijos.add('${value['description']}');
          });

          // suma del hijos, actual mas hijos sgtes
          if (i < dataBloque.length - 1 &&
              dataBloque[i + 1]['children'] != null) {
            int countCurrent =
                acum > 0 ? acum : dataBloque[i]['children'].length;

            int countNext = dataBloque[i + 1]['children'].length;

            sum = countCurrent + countNext;

            if (sum > maxItemsCol) {
              acum = 0;
              panel.add(hijos);
              hijos = [];
            } else {
              acum = sum;
            }
          } else {
            // si no hay hijos sgtes, manda el puchito restante, sin repetirlos
            if (panel.contains(hijos)) continue;
            panel.add(hijos);
          }
        } else {
          // sino tiene hijos,  ingresar los titulos sin repetirlos
          if (panel.contains(hijos)) continue;
          panel.add(hijos);
        }
      }
      paneles.add(panel);
    }
    // print('paneles $paneles');
    return paneles;
  }

  // Armar los bloques
  Widget bloqueWidgets(bloques) {
    List paneles = subcategoriesInPanel(bloques);

    List<Widget> panelsWidget = [];
    int index = 0;
    for (var panel in paneles) {
      panelsWidget.add(Visibility(
        visible: isVisible[index],
        child: Container(
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 2.0)),
            child: Column(children: [
              for (var sublist in chunkList(panel, 5))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: () {
                    List<Widget> bloquesW = [];
                    for (var item in sublist) {
                      bloquesW.add(
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 2.0)),
                              child: Column(
                                children: () {
                                  List<Widget> boxWidget = [];
                                  for (var box in item) {
                                    boxWidget.add(Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blue,
                                                width: 1.0)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(box)));
                                  }
                                  return boxWidget;
                                }(),
                              )),
                        ),
                      );
                    }

                    // Relleno
                    int rests = 5 - sublist.length;
                    bloquesW.addAll(
                      List.generate(
                        rests,
                        (index) => Expanded(child: Container()),
                      ),
                    );

                    return bloquesW;
                  }(),
                ),
            ])),
      ));
      index++;
    }

    return Container(
        child: Column(
      children: panelsWidget,
    ));
  }

  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }
}
