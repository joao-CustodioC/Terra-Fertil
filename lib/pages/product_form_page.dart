import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/models/product.dart';
import 'package:terra_fertil/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};

  @override
  void initState() {
    super.initState();
    _urlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['description'] = product.description;
        _formData['title'] = product.title;
        _formData['imageUrl'] = product.imageUrl;
        _formData['price'] = product.price;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _descriptionFocus.dispose();
    _priceFocus.dispose();
    _urlFocus.removeListener(updateImage);
    _urlFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProductFromData(_formData);
    Navigator.of(context).pop();
  }

  bool isValidImage(String url) {
    final isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    final endWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endWithFile;
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  void _showFullImage() {
    if (_imageUrlController.text.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: Container(
            color: Colors.black,
            child: Image.network(
              _imageUrlController.text,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: isIOS
          ? CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.white,
          ),
        ),
        middle: const Text(
          "Formulário Produtos",
          style: TextStyle(color: CupertinoColors.white),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _submitForm,
          child: const Icon(
            CupertinoIcons.add_circled_solid,
            color: CupertinoColors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      )
          : AppBar(
        title: const Text(
          "Formulário Produtos",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Título
              TextFormField(
                initialValue: _formData['title']?.toString(),
                decoration: _buildInputDecoration('Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (title) => _formData['title'] = title ?? '',
                validator: (_title) {
                  final title = _title ?? '';
                  if (title.trim().isEmpty) {
                    return 'Nome é obrigatório.';
                  }
                  if (title.trim().length < 3) {
                    return 'O nome precisa de pelo menos 3 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Campo Preço
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: _buildInputDecoration('Preço'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) => _formData['price'] = double.parse(price ?? '0'),
                validator: (_price) {
                  final priceString = _price ?? '-1';
                  final price = double.tryParse(priceString) ?? -1;
                  if (price <= 0) {
                    return 'Informe um preço válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Campo Descrição
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: _buildInputDecoration('Descrição'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocus,
                onSaved: (description) => _formData['description'] = description ?? '',
                validator: (_description) {
                  final description = _description ?? '';
                  if (description.trim().isEmpty) {
                    return 'Descrição é obrigatória.';
                  }
                  if (description.trim().length < 20) {
                    return 'A descrição precisa de pelo menos 20 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Campo URL da Imagem com preview e onTap para visualizar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: _buildInputDecoration('URL da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _urlFocus,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) => _formData['imageUrl'] = imageUrl ?? '',
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';
                        if (!isValidImage(imageUrl)) {
                          return 'Informe uma URL válida.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: _showFullImage,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey.shade200,
                        ),
                        alignment: Alignment.center,
                        child: _imageUrlController.text.isEmpty
                            ? const Text(
                          'Sem imagem',
                          style: TextStyle(color: Colors.grey),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: _imageUrlController.text,
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Botão Salvar no final do formulário
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(isIOS ? CupertinoIcons.add_circled_solid : Icons.save),
                  label: const Text("Salvar"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
