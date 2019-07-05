import 'package:flutter/material.dart';

class FavoriteDrawer extends StatefulWidget {

  List favoriteList;
  Function _removeFavorite;

  FavoriteDrawer(this.favoriteList, this._removeFavorite);

  @override
  _FavoriteDrawerState createState() => _FavoriteDrawerState(favoriteList, _removeFavorite);
}

class _FavoriteDrawerState extends State<FavoriteDrawer> {

  List favoriteList;
  Function _removeFavorite;

  _FavoriteDrawerState(this.favoriteList, this._removeFavorite);

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
              padding: EdgeInsets.only(top: 35.0, bottom: 0),
              child: Text("Carros favoritos",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: favoriteList.length,
                  itemBuilder: _buildFavoriteRow
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
        elevation: 8.0,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        child: ListTile(
            title: Text(favoriteList[index]["Marca"],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text('${favoriteList[index]["Modelo"]} - ${favoriteList[index]["AnoModelo"]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0
                    ),
                  ),
                ),
                Text('${favoriteList[index]["Combustivel"]} - Mês Ref. ${favoriteList[index]["MesReferencia"]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0
                  ),
                ),
                Text(favoriteList[index]["Valor"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
        )
      ),
      onDismissed: (direction) {
        _removeFavorite(index, context);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        child: Align(
            alignment: Alignment(0.9, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            )
        ),
      ),
    );
  }

}
