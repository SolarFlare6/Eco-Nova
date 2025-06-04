const mongoose=require('mongoose');
const dbase=require('../config/dbase');
const bcrypt=require('bcrypt');
//Defining user schema with properties
const {Schema} =mongoose;
const userSchema=new Schema({
    user:{
        type:String,
        required:true,
        unique:true
    },
    password:{
        type:String,
        required:true
    },
    claimedRewards: [{ type: mongoose.Schema.Types.ObjectId, ref: 'rewardsModel' }],
    actionsCompleted:[{
        actionID:{type:mongoose.Schema.Types.ObjectId,ref:'actionModel'},
        timestamp:{type:Date,default:Date.now}}],
    points:{type:Number,default:0},
    rank:{type:Number,default:0}
},{collection:'userModel'});
//Saving and password encryption
userSchema.pre('save',async function(next) {
    try {
     if (!this.isModified('password')) return next();
     var user=this;
     const salt=await(bcrypt.genSalt(10));
     const hash=await bcrypt.hash(user.password,salt);  
     user.password=hash;   
     next(); 
    } catch (error) {
        next(error);}
});
//Check password logic
userSchema.methods.comparePassword= async function(inputPassword){
try{
const isMatching=await bcrypt.compare(inputPassword,this.password);
return isMatching;}
catch (error) {
    throw error;}
}
//Defining and exporting the user model
const userModel=mongoose.model('userModel',userSchema);
module.exports=userModel;
