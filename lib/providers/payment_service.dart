import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {

  static addCustomerToDb(){
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('stripe_customers')
          .document(user.uid)
          .setData({'customerId': 'new', 'email': user.email})
          .then((val) {
            print('user added!');
          });
    });
  }
  static addCard(token) {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('stripe_customers')
          .document(user.uid)
          .collection('tokens')
          .add({'tokenId': token}).then((val) {
            print('token added!');
          });
    });
  }
}
