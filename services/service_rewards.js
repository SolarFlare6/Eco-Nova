const rewardsModel=require('../models/model_rewards');
const userModel=require('../models/model_user');
class RewardsService{
    static async claimReward(userID,rewardID){
    try {
    //Find the user and the reward
    const reward= await rewardsModel.findById(rewardID);
    const user=await userModel.findById(userID);
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
   static async addReward(rewardData){
    try{
      const reward=new rewardsModel(rewardData);
      await reward.save();  
    }catch(error) { 
    throw error;}
   }
}
module.exports=RewardsService;