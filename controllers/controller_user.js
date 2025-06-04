const userService=require('../services/service_user');
//Register
exports.registerUser=async(req,res)=>{
    try{
    const {user,password} = req.body;
    const success= await userService.registerUser(user,password);
    res.json({status:true,success:'User Created'});
    }catch (error) {
        throw error;}
    }
//Login
exports.loginUser=async(req,res)=>{
    try{
    const{user,password}=req.body;
    //Check credentials
    const userN= await userService.checkUser(user);
    if(!userN){
        throw new Error(`User doesn't exist`);}
    const checkPassword= await userN.comparePassword(password);
    if(checkPassword===false){
        throw new Error('Password is incorrect');}
    //If okay,define login data and proceed(token)
    let tokenData={_id:user._id,email:user.email};//it should be id,user,pass
    const token=await userService.generateToken(tokenData,'secretKey','2h');//function for secretKey should be added
    res.status(200).json(
        {status:true,token:token});
    } 
    catch(error){
    throw error;}
}
//Get user rank
exports.getUserRank=async(req,res)=>{
    try{
       const userRank=await userService.checkUserRank(req.user.id);
       res.status(200).json(userRank); 
    }
    catch(error) {
    res.status(400).json({message:'Bad request or invalid id',error});
    throw error;}
}