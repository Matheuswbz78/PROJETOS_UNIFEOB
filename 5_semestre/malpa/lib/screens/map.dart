import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor customIcon;
  bool _iconLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    try {
      // Ajuste o valor de `width` para aumentar o tamanho do ícone
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/marcador.png', 200);
      customIcon = BitmapDescriptor.fromBytes(markerIcon);
    } catch (e) {
      // Use um ícone padrão em caso de erro
      customIcon = BitmapDescriptor.defaultMarker;
      print('Erro ao carregar marcador personalizado: $e');
    } finally {
      setState(() {
        _iconLoaded = true; // Marca como carregado
      });
    }
  }

  Future<Uint8List> getBytesFromAsset(String asset, int width) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-21.969277693371225, -46.79905479114251),
    zoom: 8.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _iconLoaded
          ? GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _createMarkers(),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )
          : const Center(
              child: CircularProgressIndicator()), // Indicador de carregamento
    );
  }

  Set<Marker> _createMarkers() {
    return <Marker>{
      Marker(
        markerId: const MarkerId('customMarker1'),
        position: const LatLng(-21.966664004153802, -46.7731076217001),
        icon: customIcon,
      ),
      Marker(
        markerId: const MarkerId('customMarker2'),
        position: const LatLng(-22.01197939001882, -46.816130401994485),
        icon: customIcon,
      ),
      Marker(
        markerId: const MarkerId('customMarker3'),
        position: const LatLng(-21.979712246783983, -46.785342171139824),
        icon: customIcon,
      ),
      Marker(
        markerId: const MarkerId('customMarker4'),
        position: const LatLng(-21.972598666420197, -46.7969274535868),
        icon: customIcon,
      ),
      Marker(
        markerId: const MarkerId('customMarker5'),
        position: const LatLng(-21.970855616453445, -46.79172069333119),
        icon: customIcon,
      ),
      Marker(
        markerId: const MarkerId('customMarker6'),
        position: const LatLng(-21.97478089468585, -46.80039506732162),
        icon: customIcon,
      ),
      Marker(
        markerId: const MarkerId('customMarker7'),
        position: const LatLng(-21.979712246783983, -46.785342171139824),
        icon: customIcon,
      ),
    };
  }
}
