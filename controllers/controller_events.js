const eventService=require('../services/service_events');
//Post event
const postEvent=async(req,res)=>{
const{title,description,location,creator,eventLink,date}=req.body;
try{
    const newEvent=await eventService.createEvent({title,description,location,creator,eventLink,date});
    res.status(201).json({
    message: 'Event created',
    event: newEvent});
}catch(error){
   res.status(500).json({message:'Error posting event',error});}
}
//Get event
const getEvent=async(req,res)=>{
const{url}=req.query;
try{
    const fetchedEvent=await eventService.fetchEvents(url ? [url] : []);
    res.status(200).json(fetchedEvent);
}catch(error){
 res.status(500).json({message:'Error getting event',error});   }
}
module.exports={postEvent,getEvent};