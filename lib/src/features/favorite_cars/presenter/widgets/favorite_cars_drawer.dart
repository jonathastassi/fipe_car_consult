import 'package:flutter/material.dart';

class FavoriteCarsDrawer extends StatefulWidget {
  final List favoriteList;
  final Function removeFavorite;

  const FavoriteCarsDrawer({
    Key? key,
    required this.favoriteList,
    required this.removeFavorite,
  }) : super(key: key);

  @override
  _FavoriteCarsDrawerState createState() => _FavoriteCarsDrawerState();
}

class _FavoriteCarsDrawerState extends State<FavoriteCarsDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(
              top: 35.0,
              bottom: 0,
            ),
            child: const Text(
              "Carros favoritos",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.favoriteList.length,
              itemBuilder: _buildFavoriteRow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteRow(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
          child: ListTile(
            title: Text(
              widget.favoriteList[index]["Marca"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${widget.favoriteList[index]["Modelo"]} - ${widget.favoriteList[index]["AnoModelo"]}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  '${widget.favoriteList[index]["Combustivel"]} - Mês Ref. ${widget.favoriteList[index]["MesReferencia"]}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.favoriteList[index]["Valor"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
      onDismissed: (direction) {
        widget.removeFavorite(index, context);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        child: const Align(
          alignment: Alignment(0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
