// import '../model/user.dart';
//
// class Users{
//   static List<User> appUsers;
//   static User loggedInUser;
//
//   static void initAppusser(){
//     User admin = new User(id: 1000,name: "ganaa",email:'ganaa@gmail.com') ;
//     User user1 = new User(id: 1000,name: "eegii",email:'eegii@gmail.com') ;
//     appUsers = List();
//     appUsers.add(admin);
//     appUsers.add(user1);
//   }
//   static List<User> getUserFor(User user){
//     List<User> filteredUser = appUsers.where((u) => (!u.name.toLowerCase().contains(user.name.toLowerCase()))).toList();
//     return filteredUser;
//   }
// }