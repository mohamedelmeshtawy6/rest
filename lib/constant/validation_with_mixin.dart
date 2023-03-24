



mixin ValidationMixin{

  bool isEmailValid(String email)=>email.length>=10;
  bool isPasswordValid(String pass)=>pass.length>=8;
  bool isUserNameValid(String userName)=>userName.length>=2;




}