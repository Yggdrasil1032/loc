import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
        _isLoading = false;
      });
      return;
    }

    try {
      // Create a new user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pop(
          context); // Return to login page after successful registration
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred. Please try again.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img_background_design.png'),
                fit: BoxFit.cover,
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create a New Account',
                  style: TextStyle(
                    fontSize: 26,
                    // Yazı boyutu
                    fontWeight: FontWeight.bold,
                    // Kalın yazı
                    color: Colors.teal,
                    // Yazı rengi
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        // Gölgenin yayılma miktarı
                        color: Colors.black.withOpacity(0.5),
                        // Gölge rengi ve opaklığı
                        offset: Offset(2, 2), // Gölgenin kaydırılma yönü
                      ),
                    ],
                    letterSpacing: 1.5, // Harf aralığı
                  ),
                  textAlign: TextAlign.center, // Metni ortala
                ),

                SizedBox(height: 40),

                // Email input
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  // Klavye tipi e-posta için
                  style: TextStyle(
                    color: Colors.white, // Kullanıcı giriş metni rengi
                    fontSize: 16, // Metin boyutu
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.orange, // Etiket metni rengi
                      fontSize: 14, // Etiket metni boyutu
                    ),
                    hintText: 'Enter your email',
                    // İpucu metni
                    hintStyle: TextStyle(
                      color: Colors.white70, // İpucu metni rengi
                      fontSize: 14, // İpucu metni boyutu
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    // Arka plan rengi
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // Köşe yuvarlama
                      borderSide: BorderSide.none, // Çerçeveyi kaldır
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.orange, // Odaklanıldığında çerçeve rengi
                        width: 2.0, // Çerçeve kalınlığı
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.white70,
                        // Aktif olmayan durumdaki çerçeve rengi
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.email, // Sol tarafta e-posta ikonu
                      color: Colors.orange,
                    ),
                  ),
                ),

                SizedBox(height: 25),

                // Password input
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  // Şifreyi gizleme/gösterme durumu
                  style: TextStyle(
                    color: Colors.white, // Kullanıcı giriş metni rengi
                    fontSize: 16, // Metin boyutu
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange, // Etiket metni rengi
                      fontSize: 14, // Etiket metni boyutu
                    ),
                    hintText: 'Enter your password',
                    // İpucu metni
                    hintStyle: TextStyle(
                      color: Colors.white70, // İpucu metni rengi
                      fontSize: 14, // İpucu metni boyutu
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    // Arka plan rengi
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // Köşe yuvarlama
                      borderSide: BorderSide.none, // Çerçeveyi kaldır
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.deepOrange,
                        // Odaklanıldığında çerçeve rengi
                        width: 2.0, // Çerçeve kalınlığı
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.white70,
                        // Aktif olmayan durumdaki çerçeve rengi
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock, // Sol tarafta şifre ikonu
                      color: Colors.deepOrange,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons
                            .visibility_off, // Göz ikonu
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                          !_isPasswordVisible; // Şifre görünürlüğünü değiştir
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Confirm Password input
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isPasswordVisible,
                  // Şifreyi gizleme/gösterme durumu
                  style: TextStyle(
                    color: Colors.white, // Kullanıcı giriş metni rengi
                    fontSize: 16, // Metin boyutu
                  ),
                  decoration: InputDecoration(
                    labelText: 'Confrim Password',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange, // Etiket metni rengi
                      fontSize: 14, // Etiket metni boyutu
                    ),
                    hintText: 'Enter your password again',
                    // İpucu metni
                    hintStyle: TextStyle(
                      color: Colors.white70, // İpucu metni rengi
                      fontSize: 14, // İpucu metni boyutu
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    // Arka plan rengi
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // Köşe yuvarlama
                      borderSide: BorderSide.none, // Çerçeveyi kaldır
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.deepOrange,
                        // Odaklanıldığında çerçeve rengi
                        width: 2.0, // Çerçeve kalınlığı
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.white70,
                        // Aktif olmayan durumdaki çerçeve rengi
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock, // Sol tarafta şifre ikonu
                      color: Colors.deepOrange,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons
                            .visibility_off, // Göz ikonu
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                          !_isPasswordVisible; // Şifre görünürlüğünü değiştir
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),

                // Register button
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _register,
                  child: Text('Register'),
                ),
                SizedBox(height: 10),

                // Navigate back to login page
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to login page
                  },
                  child: Text(
                    'Already have an account? Login.',
                    style: TextStyle(
                      fontSize: 16, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Kalın yazı
                      color: Colors.tealAccent, // Yazı rengi
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          // Gölgenin yayılma miktarı
                          color: Colors.black.withOpacity(0.5),
                          // Gölge rengi ve opaklığı
                          offset: Offset(2, 2), // Gölgenin kaydırılma yönü
                        ),
                      ],

                    ),
                    textAlign: TextAlign.center, // Metni ortala
                  )
                  ,
                ),
              ],
            ),
          ),
        )
    );
  }
}