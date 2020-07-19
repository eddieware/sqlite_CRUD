import 'package:consumir_web_api/models/db.dart';
import 'package:consumir_web_api/models/materia.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  final Materia profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;

  //ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldProfesor;
  bool _isFieldCuatrimestreValid;
  bool _isFieldHorarioValid;
  List<Materia> _materias = [];

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerProfesor = TextEditingController();
  TextEditingController _controllerCuatrimestre = TextEditingController();
  TextEditingController _controllerHorario = TextEditingController();

  @override
  void initState() {
    if (widget.profile != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.profile.nombre;
      _isFieldProfesor = true;
      _controllerProfesor.text = widget.profile.profesor;
      _isFieldCuatrimestreValid = true;
      _controllerCuatrimestre.text = widget.profile.cuatrimestre;
      _isFieldHorarioValid = true;
      _controllerHorario.text = widget.profile.horario;
    }
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(Materia.table);
    _materias = _results.map((item) => Materia.fromMap(item)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.profile == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldProfesor(),
                _buildTextFieldCuatrimestre(),
                _buildTextFieldHorario(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.profile == null
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldNameValid == null ||
                          _isFieldProfesor == null ||
                          _isFieldCuatrimestreValid == null ||
                          !_isFieldNameValid ||
                          !_isFieldProfesor ||
                          !_isFieldCuatrimestreValid ||
                          !_isFieldHorarioValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String name = _controllerName.text.toString();
                      String profesor = _controllerProfesor.text.toString();
                      String cuatrimestre =
                          _controllerCuatrimestre.text.toString();
                      String horario = _controllerHorario.text.toString();

                      Materia profile = Materia(
                          nombre: name,
                          profesor: profesor,
                          cuatrimestre: cuatrimestre,
                          horario: horario);
                      if (widget.profile == null) {
                        DB.insert(Materia.table, profile).then((isSuccess) {
                          //setState(() => _isLoading = false);
                          if (isSuccess > 0) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Insert data failed"),
                            ));
                          }
                        });
                      } else {
                        profile.id = widget.profile.id;
                        DB.update(Materia.table, profile).then((isSuccess) {
                          //setState(() => _isLoading = false);
                          if (isSuccess > 0) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Update data failed"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.orange[600],
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nombre",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldProfesor() {
    return TextField(
      controller: _controllerProfesor,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Profesor",
        errorText: _isFieldProfesor == null || _isFieldProfesor
            ? null
            : "Profesor is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldProfesor) {
          setState(() => _isFieldProfesor = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldCuatrimestre() {
    return TextField(
      controller: _controllerCuatrimestre,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Cuatrimestre",
        errorText:
            _isFieldCuatrimestreValid == null || _isFieldCuatrimestreValid
                ? null
                : "Cuatrimestre is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldCuatrimestreValid) {
          setState(() => _isFieldCuatrimestreValid = isFieldValid);
        }
      },
    );
  }

  _buildTextFieldHorario() {
    return TextField(
      controller: _controllerHorario,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Horario",
        errorText:
            _isFieldCuatrimestreValid == null || _isFieldCuatrimestreValid
                ? null
                : "Horario is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldHorarioValid) {
          setState(() => _isFieldHorarioValid = isFieldValid);
        }
      },
    );
  }
}
