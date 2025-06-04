const actionModel=require('../models/model_actions');
const userModel=require('../models/model_user');

const getAction=async(actionName) =>{
try{
   const action=await actionModel.findOne({actionName:actionName});
   return action; 
}catch(error){
    console.log('Failed to get action',error);
    throw error;}
};
const postAction=async(actionName,userID) =>{
try{
 //Validate action and user
  const action=await getAction(actionName);
  if(!action){
    throw new Error('Invalid ecological action');}
  const user=await userModel.findOne(userID);
  if(!user){
    throw new Error('User not found');}
 //If ok,process the action to the user
  user.points+=action.actionPoints;
  user.actionsCompleted.push({actionID:action._id});
  await user.save();
  await updateUserRank();
  return{user,action};
}catch(error){
    console.log('Failed to post action',error);
    throw error;}
};
//Update user ranks based on points
const updateUserRank=async()=>{
  try {
    const users = await userModel.find().sort({ points: -1 }); 
    for (let i = 0; i < users.length; i++) {
      users[i].rank = i + 1;  
      await users[i].save();
    }
  }catch(error) {
    console.error('Error updating user rank:', error);
    throw error;}
};
//Get the top contributors (top 3 users)
const getTopContributors=async()=>{
  try{
    const topUsers = await userModel.find().sort({ points: -1 }).limit(3);
    return topUsers;
  }catch(error) {
    console.log('Error getting top contributors:', error);
    throw error;}
};
//Get today's achievements by users
const getTodaysAchievements=async(limit=10)=>{
  try {
  //Set date
   const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);
    //Get user actions and split the data into who,what and when it did
    const users = await userModel.aggregate([
        {
            $unwind: "$actionsCompleted"
        },
        {
            $match: {
                "actionsCompleted.timestamp": { $gte: startOfDay }}
        },
        {
            $lookup: {
                from: "actionModel", 
                localField: "actionsCompleted.action",
                foreignField: "_id",
                as: "actionDetails"}
        },
        { $unwind: "$actionDetails" },
        {
            $project: {
                username: "$user",
                actionName: "$actionDetails.actionName",
                timestamp: "$actionsCompleted.timestamp"}
        }, { $sample:{ size: limit }}
    ]);
    return users;
  }catch(error){
   console.error('Error getting todays achievements',error);
   throw error;}
}
//Send achievement to the app
const addAchievement=async({ userId, actionId })=>{
  try{
  const timestamp = new Date();
    const result = await userModel.updateOne(
      { _id: userId },
      {
        $push: {
          actionsCompleted:{
            action: actionId,
            timestamp: timestamp
          }
        }
      }
    );
    if (result.modifiedCount === 0) {
      throw new Error('No user was updated. Check userId and try again');
    }
  return { success: true, message: "Achievement added" };
  }catch(error) {
   console.error('Error sending achievement',error);
   throw error; }
}
module.exports = {postAction,getAction,getTopContributors,getTodaysAchievements};
