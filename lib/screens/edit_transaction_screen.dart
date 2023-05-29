import 'package:cashflow/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../providers/transaction.dart';
import '../providers/transactions.dart';
import '../providers/auth.dart';

class EditTransactionScreen extends StatefulWidget {
  static const routeName = "/edit-transaction";

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedTrx = Transaction(
    id: null,
    date: '',
    transactionValue: 0,
    transactionType: '',
    userId: 1,
    description: '',
  );

  var _initValues = {
    'id': null,
    'user_id': '',
    'transaction_type': '',
    'date': '',
    'transaction_value': 0,
    'description': ''
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final trxId = ModalRoute.of(context).settings.arguments as int;
      if (trxId != null) {
        _editedTrx =
            Provider.of<Transactions>(context, listen: false).findById(trxId);
        _initValues = {
          'id': _editedTrx.id,
          'user_id': _editedTrx.userId,
          'transaction_type': _editedTrx.transactionType,
          'date': _editedTrx.date,
          'transaction_value': _editedTrx.transactionValue,
          'description': _editedTrx.description
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedTrx.id != null) {
      try {
        await Provider.of<Transactions>(context, listen: false)
            .updateTransaction(_editedTrx.id, _editedTrx);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Oops, Terjadi Kesalahan Silahkan Periksa Lagi !'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      try {
        print('Masuk Create');
        print(
            'transaction type : ${_editedTrx.transactionType},date : ${_editedTrx.date},transaction value : ${_editedTrx.transactionValue},transaction desc : ${_editedTrx.description},');
        await Provider.of<Transactions>(context, listen: false)
            .createTransaction(_editedTrx.transactionType, _editedTrx.date,
                _editedTrx.transactionValue, _editedTrx.description);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Oops, Terjadi Kesalahan Silahkan Periksa Lagi !'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transactions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide value';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedTrx = Transaction(
                          id: _editedTrx.id,
                          userId: _editedTrx.userId,
                          transactionType: _editedTrx.transactionType,
                          date: _editedTrx.date,
                          transactionValue: _editedTrx.transactionValue,
                          description: value,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['transaction_value'].toString(),
                      decoration:
                          InputDecoration(labelText: 'Transaction Value'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _editedTrx = Transaction(
                          id: _editedTrx.id,
                          userId: _editedTrx.userId,
                          transactionType: _editedTrx.transactionType,
                          date: _editedTrx.date,
                          transactionValue: int.parse(value) ?? 99,
                          description: _editedTrx.description,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Masukkan Jumlah Uang';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: "1",
                            groupValue: _initValues['transaction_type'],
                            onChanged: (value) {
                              setState(() {
                                _initValues['transaction_type'] = value;
                                _editedTrx = Transaction(
                                  id: _editedTrx.id,
                                  userId: _editedTrx.userId,
                                  transactionType: value,
                                  date: _editedTrx.date,
                                  transactionValue: _editedTrx.transactionValue,
                                  description: _editedTrx.description,
                                );
                              });
                            },
                          ),
                          Text('Uang Masuk'),
                          SizedBox(width: 20),
                          Radio(
                            value: "2",
                            groupValue: _initValues['transaction_type'],
                            onChanged: (value) {
                              setState(() {
                                _initValues['transaction_type'] = value;
                                _editedTrx = Transaction(
                                  id: _editedTrx.id,
                                  userId: _editedTrx.userId,
                                  transactionType: value,
                                  date: _editedTrx.date,
                                  transactionValue: _editedTrx.transactionValue,
                                  description: _editedTrx.description,
                                );
                              });
                            },
                          ),
                          Text('Uang Keluar'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            await initializeDateFormatting('id_ID', null);

                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            );

                            if (selectedDate != null) {
                              final formattedDate =
                                  DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                                      .format(selectedDate);
                              setState(() {
                                _initValues['date'] = formattedDate;
                                _editedTrx = Transaction(
                                  id: _editedTrx.id,
                                  userId: _editedTrx.userId,
                                  transactionType: _editedTrx.transactionType,
                                  date: formattedDate,
                                  transactionValue: _editedTrx.transactionValue,
                                  description: _editedTrx.description,
                                );
                              });
                            }
                          },
                          child: Text('Pilih Tanggal'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          _initValues['date'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
