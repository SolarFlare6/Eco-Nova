//Event routes
const{postEvent,getEvent}=require('../controllers/controller_events');
const router=require('express').Router();
router.post('/create-event',postEvent);
router.get('/events',getEvent);
module.exports=router;