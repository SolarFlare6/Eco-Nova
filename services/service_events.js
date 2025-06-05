const Event=require('../models/model_events');
class EventService{
//Create event
static async createEvent(eventData){
  try{
      const event=new Event(eventData);
      await event.save();  
    }catch(error) {
        console.log('Error creating event');
        throw error;}}
//Fetch events-if url specified return specified,else return all,if empty return none
static async fetchEvents(urls = []){
  try{
    let backendEvents;
    if (urls.length > 0) {
      backendEvents = await Event.find({ url: { $in: urls } }); 
    }else{
      backendEvents = await Event.find();}
    return [...backendEvents];
  }catch(error) {
    console.log('Error fetching events info');
    throw error;}}
}
module.exports=EventService;
