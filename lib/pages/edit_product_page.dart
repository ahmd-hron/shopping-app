import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_provider.dart';

import '../providers/Products.dart';

// ignore: must_be_immutable
class EditProductPage extends StatefulWidget {
  static const String routeName = '/edit-product-page';
  Product product;
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  bool _isloading = false;
  String id;

  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct =
      Product(description: '', id: '', imageUrl: '', price: 0, title: '');

  //focus nodes will stick in memory forever if i don't clear them manually
  //returning null on validator method in form means the value is alwyas currect

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final bool isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();

      if (widget.product == null) {
        setState(() {
          _isloading = true;
        });
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('couldn\'t add the product '),
              content: Text(
                  'please check your internet connection and try again later '),
              elevation: 4,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            ),
          );
        }
        //  finally {
        //   _isloading = false;
        //   Navigator.of(context).pop();
        // }
      } else {
        setState(() {
          _isloading = true;
        });
        _editedProduct.isFavorite = widget.product.isFavorite;
        print('this is the fkn id $id');
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(id, _editedProduct);
      }
    }
    //since we alwyas return a Future here we're going to wait tell we get response
    //then this code will run in every case
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments;
    widget.product =
        Provider.of<ProductsProvider>(context, listen: false).findById(id);
    _imageUrlController.text =
        widget.product == null ? '' : widget.product.imageUrl;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildFOrm(widget.product),
            ),
    );
  }

  Widget _buildFOrm(Product product) {
    return Form(
      key: _form,
      child: ListView(
        children: [
          _buildTitleInputFormField(product),
          _buildPriceInputFormText(product),
          __buildDecriptionInputFormText(product),
          _buildImageRow(product),
        ],
      ),
    );
  }

  Widget _buildTitleInputFormField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.title,
      decoration: InputDecoration(labelText: 'Title'),
      validator: (value) => validateTitle(value),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_priceFocusNode),
      onSaved: (titleValue) {
        _editedProduct = Product(
          description: _editedProduct.description,
          id: _editedProduct.id,
          imageUrl: _editedProduct.imageUrl,
          price: _editedProduct.price,
          title: titleValue,
        );
      },
    );
  }

  String validateTitle(String value) {
    if (value.length <= 2) return 'titles should have more than 2 chars';
    return null;
  }

  Widget _buildPriceInputFormText(Product product) {
    return TextFormField(
      initialValue: product == null ? ' ' : product.price.toString(),
      decoration: InputDecoration(labelText: 'Price'),
      validator: (value) => validatePric(value),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _priceFocusNode,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_descriptionNode),
      onSaved: (value) {
        _editedProduct = Product(
          description: _editedProduct.description,
          id: _editedProduct.id,
          imageUrl: _editedProduct.imageUrl,
          price: double.parse(value),
          title: _editedProduct.title,
        );
      },
    );
  }

  String validatePric(String value) {
    if (value.isEmpty) return 'please enter a price';
    if (double.tryParse(value) == null) return 'please enter a valied number';
    if (double.parse(value) <= 0) return 'please enter a number greater than 0';
    return null;
  }

  Widget __buildDecriptionInputFormText(Product product) {
    return TextFormField(
      initialValue: product == null ? ' ' : product.description,
      decoration: InputDecoration(
        labelText: 'Description',
      ),
      validator: (value) => value.length < 5 ? 'please be more specific' : null,
      maxLines: 3,
      // textInputAction: TextInputAction.next, you can't set this with multiline keyboard because it will override it
      keyboardType: TextInputType.multiline,
      focusNode: _descriptionNode,
      onSaved: (discriptionValue) {
        _editedProduct = Product(
          description: discriptionValue,
          id: _editedProduct.id,
          imageUrl: _editedProduct.imageUrl,
          price: _editedProduct.price,
          title: _editedProduct.title,
        );
      },
    );
  }

  Widget _buildImageRow(Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(
            top: 10,
            right: 12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? Text('Enter a URL')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Image Url',
            ),
            validator: (value) => validateImage(value),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            controller: _imageUrlController,
            onSaved: (imageUrlValue) {
              _editedProduct = Product(
                description: _editedProduct.description,
                id: _editedProduct.id,
                imageUrl: imageUrlValue,
                price: _editedProduct.price,
                title: _editedProduct.title,
              );
            },
            onEditingComplete: () {
              setState(() {});
            },
            onFieldSubmitted: (value) {
              _saveForm();
            },
          ),
        ),
      ],
    );
  }

  String validateImage(String value) {
    if (value.isEmpty) return 'Please enter an image URL';
    if (!value.startsWith('https://') && !value.startsWith('http'))
      return 'please enter a valied URl';
    if (!value.endsWith('.jpg') &&
        !value.endsWith('.png') &&
        !value.endsWith('jpeg')) return 'Please enter a valied image URL';
    return null;
  }
}
