//Reward route
const{claimReward,addReward}=require('../controllers/controller_rewards');
const router=require('express').Router();
router.post('/claimReward',claimReward);
router.post('/addReward',addReward);
module.exports=router;