const userModel=require('../models/model_user');
const jwt=require('jsonwebtoken');
class UserService{
    //Register
    static async registerUser(user,password){
     try {
     const newUser= new userModel({user,password});
     return await newUser.save();   
     } catch (error) {
        throw error;}
    }
    //Check username
    static async checkUser(user){
    try {
       return await userModel.findOne({user});
    } catch (error){
     throw error;}
    }
    //Generate jwt
    static async generateToken(tokenData,secretKey,expiration){
    return jwt.sign(tokenData,secretKey,{expiresIn:expiration});
   }
   }
    module.exports=UserService;