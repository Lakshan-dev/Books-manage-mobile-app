import 'dart:convert';
import 'dart:ffi';

class book{
  late String id;
  late String name;
  late String desc;
  late String image;
  late String price;
  late String quantity;
  late String damaged;
  late String d_quantity;
  late String author;
  late String category;

  book(this.id, this.name, this.desc, this.image, this.price, this.quantity, this.damaged, this.d_quantity, this.author, this.category);

  book.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    image = json['image'];
    price = json['price'];
    quantity = json['quantity'];
    damaged = json['damaged'];
    d_quantity = json['d_quantity'];
    author = json['author'];
    category = json['category'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['image'] = this.image;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['damaged'] = this.damaged;
    data['d_quantity'] = this.d_quantity;
    data['author'] = this.author;
    data['category'] = this.category;
    return data;
  }
}