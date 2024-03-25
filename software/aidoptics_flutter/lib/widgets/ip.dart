import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IpAddressInputWidget extends StatefulWidget {
  final Function(String)? onSetIp;
  final String? initialIp;

  IpAddressInputWidget({Key? key, this.onSetIp, this.initialIp}) : super(key: key);

  @override
  _IpAddressInputWidgetState createState() => _IpAddressInputWidgetState();
}

class _IpAddressInputWidgetState extends State<IpAddressInputWidget> {
  late TextEditingController _ipController;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(text: widget.initialIp);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _ipController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(
            //     RegExp(r'^\d{0,3}(\.\d{0,3}){0,3}$'),
            //   ),
            // ],
            decoration: const InputDecoration(
              labelText: 'Enter IP Address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an IP address';
              }
              // You can add more advanced IP address validation logic here if needed
              if (!isValidIpAddress(value)) {
                return 'Invalid IP address format';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (Form.of(context).validate()) {
                // Validation passed, return the entered IP address
                String ipAddress = _ipController.text;
                // Callback to the parent widget with the valid IP address
                widget.onSetIp?.call(ipAddress);
              }
            },
            child: const Text('Set IP'),
          ),
        ],
      ),
    );
  }

  bool isValidIpAddress(String value) {
    // Add more sophisticated IP address validation logic if needed
    final RegExp regExp = RegExp(r'^\d{1,3}(\.\d{1,3}){0,3}$');
    return regExp.hasMatch(value);
  }
}