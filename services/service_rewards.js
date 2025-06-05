const Rewards=require('../models/model_rewards');
const User=require('../models/model_user');
class RewardsService{
    static async claimReward(userID,rewardID){
    try {
    //Find the user and the reward
    const reward= await Rewards.findById(rewardID);
    const user=await User.findById(userID);
    //If not found or not enough points
    if(!user||!reward)throw new Error('User or Reward not found');
    if(user.points<reward.cost)throw new Error('Not enough points for this reward');
    //Points calculation and reward claiming if successful
    user.points-=reward.cost;
    user.claimedRewards.push(reward);
    await user.save();
    return `Reward "${reward.name}" collected`;
    }catch(error){
     throw error;}
    }
   //Add and save reward
   static async addReward(rewardData){
    try{
      const reward=new Rewards(rewardData);
      await reward.save();  
    }catch(error) { 
    throw error;}
   }
//Get rewards based on url,if not returns all available
   static async getRewards(urls = []){
    try{
    let backendRewards;
    if (urls.length > 0) {
     backendRewards = await Rewards.find({ url: { $in: urls } }); 
    }else{
     backendRewards = await Rewards.find();}
    return [...backendRewards];
  }catch(error) {
    console.log('Error fetching events info');
    throw error;}} 
   }
module.exports=RewardsService;
