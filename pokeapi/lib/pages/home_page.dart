import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista para almacenar la infor del json (api)
  late List pokedex = [];

  dynamic color(index) {
    dynamic setColor;
    switch (pokedex[index]["type"][0]) {
      case "Grass":
        setColor = Colors.greenAccent;
        break;
      case "Fire":
        setColor = Colors.redAccent;
        break;
      case "Water":
        setColor = Colors.blue;
        break;
      case "Posion":
        setColor = Colors.deepPurpleAccent;
        break;
      case "Electric":
        setColor = Colors.amber;
        break;
      case "Rock":
        setColor = Colors.grey;
        break;
      case "Ground":
        setColor = Colors.brown;
        break;
      case "Psychic":
        setColor = Colors.indigo;
        break;
      case "Bug":
        setColor = Colors.lightGreenAccent;
        break;
      case "Ghost":
        setColor = Colors.deepPurple;
        break;
      case "Normal":
        setColor = Colors.white12;
        break;
      case "Fighting":
        setColor = Colors.orange;
        break;
      default:
        setColor = Colors.pink;
    }
    return setColor;
  }

  @override
  void initState() {
    super.initState();
    // Comprobar si la propiedad de mounted ha sido montado...llama a fetchPokeapi()
    if (mounted) {
      fetchPokeapi();
    }
  }

  //Diseño 'visualizacion'
  @override
  Widget build(BuildContext context) {
    //obtener el ancho de la pantalla
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 128, 64, 48),
              Color.fromARGB(255, 0, 0, 0),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  "assets/pokeball.png",
                  width: 170,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 20,
              child: Text(
                "Pokedex",
                style: TextStyle(
                  color: Colors.black12.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Positioned(
              top: 150,
              bottom: 0,
              width: width,
              child: Column(
                children: [
                  pokedex != null
                      ? Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                //Asignar el aspecto que van a tener todos los child (ancho/alto)
                                childAspectRatio: 3 / 5,
                              ),
                          itemCount: pokedex.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              //Adapta el tap(el dedo)
                              child: InkWell(
                                //area para los moviles que contiene botones abajo
                                child: SafeArea(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: width,
                                        margin: const EdgeInsets.only(top: 80),
                                        decoration: const BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              //El numero posicion en top 90 y left 15
                                              top: 90,
                                              left: 15,
                                              child: Text(
                                                pokedex[index]["num"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Color.fromARGB(255, 128, 64, 48),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              //El texto posicion en top 130 y left 15
                                              top: 130,
                                              left: 15,
                                              child: Text(
                                                pokedex[index]["name"],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              //El texto posicion en top 170 y left 15
                                              top: 170,
                                              left: 15,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                child: Text(
                                                  pokedex[index]["type"][0],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: color(index),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: color(index),
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 1.0,
                                                        blurRadius: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        child: CachedNetworkImage(
                                          imageUrl: pokedex[index]["img"],
                                          height: 180,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      : const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CONSUMIR API
  void fetchPokeapi() {
    var url = Uri.https(
      "raw.githubusercontent.com",
      "/Biuni/PokemonGO-Pokedex/refs/heads/master/pokedex.json",
    );
    http
        .get(url)
        .then((value) {
          // Si es exito '200'...
          if (value.statusCode == 200) {
            // captura en la variable data 'decodificando el json'
            var data = jsonDecode(value.body);
            pokedex = data["pokemon"];
            setState(() {});
            if (kDebugMode) {
              print(pokedex);
            }
          }
        })
        .catchError((e) {
          if (kDebugMode) {
            print(e);
          }
        });
  }
}
