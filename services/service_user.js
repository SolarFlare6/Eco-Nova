const userModel=require('../models/model_user');
const jwt=require('jsonwebtoken');
class UserService{
    //Register
    static async registerUser(user,password){
     try{
     const newUser= new userModel({user,password});
     return await newUser.save();   
     }catch (error) {
        throw error;}
    }
    //Check username
    static async checkUser(user){
    try{
       return await userModel.findOne({user});
    }catch (error){
     throw error;}
    }
    //Generate jwt
    static async generateToken(tokenData,secretKey,expiration){
    return jwt.sign(tokenData,secretKey,{expiresIn:expiration});
   }
   //Return user current rank
   static async checkUserRank(userID){
      try{
   const users = await userModel.find().sort({ points: -1 }).select('_id points');
   const rank = users.findIndex((user) => user._id.toString() === userID) + 1;
   return rank;
      }catch(error){
       throw error;}
   }
   }
    module.exports=UserService;