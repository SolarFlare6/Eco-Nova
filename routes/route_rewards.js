//Reward route
const{claimReward,addReward,getRewards}=require('../controllers/controller_rewards');
const router=require('express').Router();
router.post('/claimReward',claimReward);
router.post('/addReward',addReward);
router.get('/rewards',getRewards);
module.exports=router;
