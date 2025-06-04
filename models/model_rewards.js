//Rewards model
const mongoose=require('mongoose');
const{Schema}=mongoose;
const rewardsSchema=new Schema({
rewardName:String,
cost:Number});
const rewardsModel=mongoose.model('rewardsModel',rewardsSchema);
module.exports=rewardsModel;