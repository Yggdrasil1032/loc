import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:life_on_campus/register_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  bool _isPasswordVisible = false;

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // After login, navigate to the main page if the user is authenticated
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage()), // Go to MainPage after login
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(
              color: Colors.white, // Başlık metni rengi
              fontSize: 30, // Başlık metni boyutu
              fontWeight: FontWeight.bold, // Başlık metni kalınlığı
            ),
          ),
          backgroundColor: Colors.deepOrangeAccent, // Arka plan rengi
          elevation: 4, // Gölge efekti
          centerTitle: true, // Başlık ortalanmış
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white), // Geri butonu
            onPressed: () {
              Navigator.pop(context); // Önceki sayfaya dön
            },
          ),
        ),

        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img_background_design.png'),
                fit: BoxFit.cover,
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:

            Column(
              children: [
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white), // Yazı rengi
                  decoration: InputDecoration(
                    labelText: 'Email', // Label metni
                    labelStyle: TextStyle(
                      color: Colors.orange, // Label metninin rengi
                      fontSize: 16, // Label yazı boyutu
                      fontWeight: FontWeight.bold, // Label yazı kalınlığı
                    ),
                    hintText: 'Enter your email', // Kullanıcıya ipucu metin
                    hintStyle: TextStyle(
                      color: Colors.grey, // İpucu metnin rengi
                      fontStyle: FontStyle.italic, // İpucu metnin stili
                    ),
                    filled: true, // Arka plan doldurulsun mu
                    fillColor: Colors.black.withOpacity(0.5), // Arka plan rengi
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                      borderSide: BorderSide(
                        color: Colors.white70, // Varsayılan kenar rengi
                        width: 2.0, // Kenar kalınlığı
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // Odaklanıldığında kenar rengi
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.orange), // Başta ikon
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        _emailController.clear(); // E-posta alanını temizler
                      },
                    ), // Sonda ikon
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Colors.white), // Yazı rengi
                  decoration: InputDecoration(
                    labelText: 'Password', // Label metni
                    labelStyle: TextStyle(
                      color: Colors.orange, // Label metninin rengi
                      fontSize: 16, // Label yazı boyutu
                      fontWeight: FontWeight.bold, // Label yazı kalınlığı
                    ),
                    hintText: 'Enter your password', // Kullanıcıya ipucu metin
                    hintStyle: TextStyle(
                      color: Colors.grey, // İpucu metnin rengi
                      fontStyle: FontStyle.italic, // İpucu metnin stili
                    ),
                    filled: true, // Arka plan doldurulsun mu
                    fillColor: Colors.black.withOpacity(0.5), // Arka plan rengi
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                      borderSide: BorderSide(
                        color: Colors.white70, // Varsayılan kenar rengi
                        width: 2.0, // Kenar kalınlığı
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // Odaklanıldığında kenar rengi
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.key, color: Colors.orange), // Başta ikon
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons
                          .visibility_off, // Göz ikonu
                        color: Colors.deepOrange,),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                            !_isPasswordVisible; // Şifre görünürlüğünü değiştir
                          });
                        },
                    ), // Sonda ikon
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Arka plan rengi
                    foregroundColor: Colors.white, // Metin rengi
                    textStyle: TextStyle(
                      fontSize: 16, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Yazı kalınlığı
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // İç boşluk
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                    ),
                    elevation: 5, // Gölge efekti
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login, color: Colors.white), // Sol başta giriş ikonu
                      SizedBox(width: 8), // İkon ve metin arasındaki boşluk
                      Text('Login'),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                // Navigate to Register page
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal, // Metin rengi
                    textStyle: TextStyle(
                      fontSize: 16, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Yazı kalınlığı
                    ),
                    backgroundColor: Colors.black.withOpacity(0.5), // Arka plan rengi
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // İç boşluk
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add, color: Colors.teal), // Başına ikon ekleniyor
                      SizedBox(width: 8), // İkon ve metin arasındaki boşluk
                      Text('Don’t have an account? Register'),
                    ],
                  ),
                ),

                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}

