import 'package:cashflow/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedTrx = Transaction(
    id: null,
    date: '',
    transactionValue: 0,
    transactionType: '',
    userId: 1,
  );

  var _initValues = {
    'id': 0,
    'user_id': '',
    'transaction_type': '',
    'date': '',
    'transaction_value': 0,
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
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
          'transaction_type': _editedTrx.transactionValue,
          'date': _editedTrx.date,
          'transaction_value': _editedTrx.transactionValue
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') ||
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return null;
      }
      setState(() {});
    }
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
      await Provider.of<Transactions>(context, listen: false)
          .updateTransactions(_editedTrx.id, _editedTrx);
    } else {
      try {
        await Provider.of<Transactions>(context, listen: false)
            .createTransaction(_editedTrx.transactionType, _editedTrx.date,
                _editedTrx.transactionValue);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong.'),
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
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
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
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
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
                        // _e = Product(
                        //   title: value,
                        //   price: _editedProduct.price,
                        //   description: _editedProduct.description,
                        //   imageUrl: _editedProduct.imageUrl,
                        //   id: _editedProduct.id,
                        //   isFavorite: _editedProduct.isFavorite,
                        // );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        // _editedProduct = Product(
                        //   title: _editedProduct.title,
                        //   price: double.parse(value),
                        //   description: _editedProduct.description,
                        //   imageUrl: _editedProduct.imageUrl,
                        //   id: _editedProduct.id,
                        //   isFavorite: _editedProduct.isFavorite,
                        // );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      // onSaved: (value) {
                      //   _editedProduct = Product(
                      //     title: _editedProduct.title,
                      //     price: _editedProduct.price,
                      //     description: value,
                      //     imageUrl: _editedProduct.imageUrl,
                      //     id: _editedProduct.id,
                      //     isFavorite: _editedProduct.isFavorite,
                      //   );
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter description';
                        }
                        if (value.length < 10) {
                          return 'Description should be more than 10 characters';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1), color: Colors.grey),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            // onSaved: (value) {
                            //   _editedProduct = Product(
                            //     title: _editedProduct.title,
                            //     price: _editedProduct.price,
                            //     description: _editedProduct.description,
                            //     imageUrl: value,
                            //     id: _editedProduct.id,
                            //     isFavorite: _editedProduct.isFavorite,
                            //   );
                            // },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image url';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid url';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image url.';
                              }
                              return null;
                            },
                          ),
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
