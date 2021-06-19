import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contacts.dart';
import 'package:flutter_contacts/providers/permission_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';


class ContactScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final permission = watch(permissionProvider(context));

    if (permission == PermissionStatus.granted) {
      return Contacts();
    } else {
      return Container();
    }
  }
}

class Contacts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Contact contacts = Contact();
    final contact = watch(contactProvider);
    return Scaffold(
      body:  ListView.builder(
          itemCount: contact?.length ?? 0,
          itemBuilder: (context, index) {
            Contact contactUser = contact?.elementAt(index);
            return Container(
              height: 100,
              child: ListTile(
                leading: (contactUser.avatar != null &&
                    contactUser.avatar.length > 0)
                    ? CircleAvatar(
                    backgroundImage: MemoryImage(contactUser.avatar))
                    : CircleAvatar(child: Text(contactUser.initials())),
                title: Text(contact[index].displayName),
                subtitle: Column(
                  children:
                  contact[index].phones.map((e) => Text(e.value)).toList(),
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(context: context, builder: (context) =>
                              AlertDialog(
                                content: Text('Are you sure'),
                                title: Text('You want to remove'),
                                actions: [
                                  TextButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Text('No')),
                                  TextButton(onPressed: () {
                                    context
                                        .read(contactProvider.notifier)
                                        .removeContact(contactUser, context);
                                    Navigator.pop(context);
                                  }, child: Text('Yes')),
                                ],
                              ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              UpdateForm(formKey: _formKey,
                                  contactUser: contactUser)));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'First name'),
                                onSaved: (v) => contacts.givenName = v,
                              ),
                              TextFormField(
                                decoration:
                                const InputDecoration(labelText: 'Phone'),
                                onSaved: (v) =>
                                contacts.phones = [
                                  Item(label: "mobile", value: v)
                                ],
                                keyboardType: TextInputType.phone,
                              ),
                              TextFormField(
                                decoration:
                                const InputDecoration(labelText: 'E-mail'),
                                onSaved: (v) =>
                                contacts.emails = [
                                  Item(label: "work", value: v)
                                ],
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState.save();
                                  context
                                      .read(contactProvider.notifier)
                                      .addContacts(contacts);
                                  context.refresh(contactProvider.notifier);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}



class UpdateForm extends StatelessWidget {
  const UpdateForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.contactUser,
  }) : _formKey = formKey, super(key: key);

  final GlobalKey<FormState> _formKey;
  final Contact contactUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue:
                      contactUser.givenName ?? "",
                  decoration: const InputDecoration(
                      labelText: 'First name'),
                  onSaved: (v) =>
                      contactUser.givenName = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Phone'),
                  onSaved: (v) => contactUser.phones = [
                    Item(label: "mobile", value: v)
                  ],
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'E-mail'),
                  onSaved: (v) => contactUser.emails = [
                    Item(label: "work", value: v)
                  ],
                  keyboardType:
                      TextInputType.emailAddress,
                ),

                ElevatedButton(
                  onPressed: () async{
                    _formKey.currentState.save();
                    await ContactsService.updateContact(contactUser);
                    context.refresh(contactProvider.notifier);
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
