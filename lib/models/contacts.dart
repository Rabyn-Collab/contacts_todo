import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





class ContactsNotifier extends StateNotifier<List<Contact>>{


  ContactsNotifier( [List<Contact> state]) : super(state ?? []){
refreshContacts();
  }


  Future<void> refreshContacts() async {
    var contacts = (await ContactsService.getContacts(
        withThumbnails: false))
        .toList();
      state = contacts;

    for (final contact in contacts) {
      ContactsService.getAvatar(contact).then((avatar) {
        if (avatar == null) return;
         contact.avatar = avatar;
      });
    }
  }


    void addContacts( Contact contact){
      ContactsService.addContact(contact);
      state = [...state, contact];

    }

    void removeContact(Contact contact, BuildContext context){
      ContactsService.deleteContact(contact);
      context.refresh(contactProvider.notifier);
    }


}

final contactProvider = StateNotifierProvider<ContactsNotifier, List<Contact>>((ref) => ContactsNotifier());