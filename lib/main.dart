import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;                                              // Imported this package to read api link
import 'model/meal.dart';                                                             // Imported the class model to use here

void main() {
  runApp(
    MaterialApp(home: MyApp()),       // Command to run the app - Uygulamayı başlatan komut
  );
}
class MyApp extends StatelessWidget {
  MyApp({super.key});
  List<Meal> meals = [];  // List that will hold the data fetched from api link - Api linkinden çekilen verinin atılacağı liste

  /*

  In this part, I have used a Future type method 'getMeals()' to fetch the data from api. Future method allows us to process data beforehand
  Bu kısımda, Future tipinde bir metod olan 'getMeals()' kullanılarak api'deki veri çekildi. Future metodu veriyi önden işlememizi sağlar.

  */
  Future getMeals() async {
    /*
       I have defined two variables, 'response' for getting the api link and 'jsonData' for decoding the body of the response
       İki değişken ataması yapıldı, api linkin elde edilmesi için 'response' ve vücudunun decode edilmesi için 'jsondata' kullanıldı

    */
    var response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=a')); // Uri.parse() used for full url link - Uri.parse() url linki için kullanıldı
    var jsonData = jsonDecode(response.body);

    /*
    In the 'meal.dart', class 'Meal' has been created. For each meal name that is read from the decoded json file, assign the value to the
    'strMeal' variable in the Meal class and add it into the meals list.

    'meal.dart' dosyasında, 'Meal' class ı oluşturuldu. Json dosyasından okunan her yemek adı için, okunan veriyi 'strMeal' değişkenine ata ve
    meals listesine ekle.

    */
    for (var eachMeal in jsonData['meals']){
      final meal = Meal(
        strMeal: eachMeal['strMeal'],
      );
      meals.add(meal);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(                                                      // Widget for constructing a page - Sayfa oluşturmak için kullanılan widget
      appBar: AppBar(                                                     // Widget for AppBar - AppBar için widget
        backgroundColor: Colors.purple[100],                              // Background color for the AppBar - AppBar için arkaplan rengi
        title: Text(                                                      // Text written in AppBar, with some font size and context - Font büyüklüğü ve içerğini içeren AppBar içindeki yazı.
          'Recipes',
          style: TextStyle(
            fontSize: 25,
          ),
        ),

      ),
      /*
      FutureBuilder() has been used to get the list first, check if the list has been read, then act accordingly

      FutureBuilder() önce listeyi almak, listenin okunup okunmadığını anlamak, daha sonra buna göre kararlar verilmesi için kullanıldı.
      */
      body: FutureBuilder(
        future: getMeals(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){         // Check if the list has been read - Listenin okunup okunmadığını kontrol et
            return ListView.builder(                                     // If it is read, return a ListView - Okunmuşsa, ListView döndür
                itemCount: meals.length,                                 // Length of the list is the amount of items that will be created. - Listenin uzunluğu kadar öge oluştur.
                itemBuilder: (context, index){                           // Context of the items - Ögelerin içeriği
                  return ListTile(                                       // Return a ListTile - Bir ListTile döndür.
                    leading: Icon(Icons.list),                           // Put an icon at the start of each meal name - Her bir yemeğin başına ikon ekle
                    title: Text(
                        meals[index].strMeal,                            // Put each meal into ListTile text - Her bir yemeği ListTile yazısına ata.
                      style: TextStyle(
                        fontSize: 20,                                    // Adjust the font size for the text, Yazının font büyüklüğünü ayarla.
                      ),
                    ),
                  );
                  },

            );
          }
          else{                                                          // If list is not read - Eğer liste okunmamışsa
            return Center(
              child: CircularProgressIndicator(),                        // Put a loading indicator until the list has been loaded - Liste okunana kadar bir yükleme sembolü koy
            );
          }
        },
      ),
    );
  }
}

