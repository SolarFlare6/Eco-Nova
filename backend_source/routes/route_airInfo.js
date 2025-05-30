//Air route
const{getAQNews}=require('../controllers/controller_airInfo');
const router=require('express').Router();
router.get('/info-aq',getAQNews);
module.exports=router;