const rewardsService=require('../services/service_rewards');
//Claim reward
exports.claimReward=async(req,res)=>{
    try{
    const reward=await rewardsService.claimReward(req.user.id,req.body.rewardID);
    res.status(200).json(reward);}
    catch(error){
    res.status(400).json({message:'Error getting reward',error});
    throw error;}
}
//Add reward
exports.addReward=async(req,res)=>{
const{rewardName,cost}=req.body;
try {
    const reward=await rewardsService.addReward({rewardName,cost});
    res.status(201).json({message:'Reward created',reward:reward})
}catch(error){
    res.status(500).json({message:'Error creating reward'},error);  
    throw error;}
}