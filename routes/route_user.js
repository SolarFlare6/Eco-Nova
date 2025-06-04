//User routes
const userController=require('../controllers/controller_user');
const router=require('express').Router();
router.post('/register',userController.registerUser);
router.post('/login',userController.loginUser);
module.exports=router;