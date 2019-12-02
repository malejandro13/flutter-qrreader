import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/model/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

import 'direcciones_page.dart';
import 'mapas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QE Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScansTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {

    // https://fernando-herrera.com
    // geo:40.724233047051705,-74.00731459101564

    //String futureString = '';
    String futureString = 'https://fernando-herrera.com';

    // try {
    //   futureString =  await new QRCodeReader().scan();  
    // } catch(e) {
    //   futureString = e.toString();
    // }

    // print('futureString: $futureString');

    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      if(Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(context, scan);   
        });
      }else{
        utils.abrirScan(context, scan);
      }
    
    }

    
  }

  Widget _callPage(int paginaActual){
    switch(paginaActual){
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      
      default:
        return  MapasPage();
    }
  }

  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;          
        });
        
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('mapa')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('direcciones')
        )
      ],
    );
  }
}