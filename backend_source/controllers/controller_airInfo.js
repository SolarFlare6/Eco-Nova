const airService=require('../services/service_airInfo');
//Get events from API
//Air quality
const getAQNews=async(req,res)=>{
    try{
    const cords=process.env.CORDS.split(',');
    const newsForAQ=await airService.getAirQualityData(...cords);
    res.status(200).json(newsForAQ);
    }catch(error) {
    res.status(500).json({message:'Error getting news for Air Quality',error});}
}
module.exports={getAQNews};