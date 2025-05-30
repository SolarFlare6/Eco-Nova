const{getAction,postAction,getTopContributors}=require('../services/service_actions');
//Post eco action
const postEcoAction=async(req,res) =>{
 const{actionName,userID}=req.body;
 try{
  const postedAction=await postAction(actionName,userID);
  res.status(201).json({message:'Action posted successfully',postedAction}); 
 }catch(error){
  res.status(400).json({message:'Error posting action'},error);
  throw error;
 }   
};
//Get eco action by name
const getEcoAction=async(req,res) =>{
  const{actionName}=req.body;
 try{
  const fetchedAction=await getAction(actionName);
  res.status(200).json({message:'Action fetched successfully',fetchedAction});
 }catch(error){
  res.status(500).json({message:'Error getting action'},error);
  throw error;
 }     
};
//Get top 3 contributors
const getEcoTopContributors=async(req,res) =>{
 try{
  const topContributors=await getTopContributors();
  res.status(200).json({message:'The top 3 contributors: ',topContributors});
 }catch(error){
  res.status(500).json({message:'Error getting the contributors'},error);
  throw error;
 }    
};
module.exports={postEcoAction,getEcoAction,getEcoTopContributors};