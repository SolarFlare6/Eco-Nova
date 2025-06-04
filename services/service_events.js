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
//Fetch events
static async fetchEvents(){
  try{
      //Fetch events from dbase
      const backendEvents = await Event.find();
      const showEvents = [...backendEvents];
      return showEvents; 
    }catch(error) {
     console.log('Error fetching events info');
     throw error;}}
}
module.exports=EventService;