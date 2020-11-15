import 'dart:convert';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:cogniplus/src/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;

class CuestionarioPage extends StatefulWidget {
  final Map<String, dynamic> info;

  const CuestionarioPage({Key key, this.info}) : super(key: key);
  @override
  _CuestionarioPageState createState() => _CuestionarioPageState();
}

class _CuestionarioPageState extends State<CuestionarioPage> {
  AdultoModel _adulto;
  int _idVideo;
  int _idModulo;
  var _response;
  ConnectivityResult _connectivity;

  @override
  void initState() {
    _setInit();
    super.initState();
  }

  _setInit() async {
    _response = _getRequest();
    _connectivity = await Connectivity().checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    _adulto = widget.info['adulto'];
    _idModulo = widget.info['idModulo'];
    _idVideo = widget.info['idVideo'];
    //VideoModel video = VideoModel(id: data[1], idModulo: data[2]);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(FontAwesomeIcons.question, color: Colors.white),
                  onPressed: () {}),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('home');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.solidUserCircle,
                        color: Colors.white, size: 42),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${_adulto.nombres}',
                            style: utils.estBodyAccent16),
                        Text('${_adulto.apellidos}',
                            style: utils.estBodyAccent19),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white),
                  onPressed: () => utils.logoff(context)),
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: _getBody(context, _adulto),
        )));
  }

  Widget _getBody(BuildContext context, AdultoModel adulto) {
    return FutureBuilder(
      future: _response,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List<dynamic> questions = snapshot.data;
        int length = questions.length;
        return Container(
          padding: EdgeInsets.fromLTRB(80, 20, 80, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "PREGUNTAS",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 35),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: length,
                  itemBuilder: (contex, index) {
                    return Column(
                      children: [
                        Text(
                          "${questions[index]['question_text']}",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        _starsQuestion(context,
                            double.parse(questions[index]['assessment'])),
                        SizedBox(height: (index == (length - 1)) ? 35 : 15),
                      ],
                    );
                  }),
              _getBotones(context),
            ],
          ),
        );
      },
    );
  }

  Widget _starsQuestion(BuildContext context, double assessment) {
    return Center(
      child: SmoothStarRating(
          allowHalfRating: false,
          onRated: (value) {
            setState(() {
              
            });
          },
          starCount: 5,
          rating: assessment,
          size: 40,
          color: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          spacing: 0.0),
    );
  }

  Future<List<dynamic>> _getRequest() async {
    var response = await Api().getDataFromApi(url: '/questions');
    return json.decode(response.body);
  }

  Widget _makeQuestionsWidgets(BuildContext context) {
    return Text("");
  }

  Widget _getBotones(BuildContext context) {
    bool isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return Flex(
      direction: (isLandscape) ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: SizedBox(
              width: (isLandscape) ? 150 : double.infinity,
              height: 50,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                  child: Text('ANTERIOR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)))),
          onPressed: () => Navigator.of(context).pop(),
        ),
        (isLandscape)
            ? Container()
            : SizedBox(
                height: 10.0,
              ),
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: SizedBox(
              width: (isLandscape) ? 150 : double.infinity,
              height: 50,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                  child: Text('SIGUIENTE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)))),
          onPressed: () {},
        )
      ],
    );
  }
}
