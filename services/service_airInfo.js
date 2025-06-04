const axios=require('axios');
class AirService {
  //Fetch air quality data from AQICN API
  static async getAirQualityData(latitude,longitude) {
    const apiKey=process.env.AIRQ_API_KEY;
    const url = `https://api.waqi.info/feed/geo:${latitude};${longitude}/?token=${apiKey}`; // Use the AQICN API for air quality
    try{
      const response = await axios.get(url);
      const data = response.data;
      if(data.status === "ok") {
        return {
          city: data.data.city.name, 
          aqi: data.data.aqi, 
          pollutant: data.data.dominentpol,
           pm25: data.data.iaqi.pm25?.v,  
          pm10: data.data.iaqi.pm10?.v,  
          no2: data.data.iaqi.no2?.v,    
          o3: data.data.iaqi.o3?.v,      
          lastUpdate: data.data.time.iso
        };  // Return a simplified air quality data
      }else{
        throw new Error('Air quality data fetch failed');
      }
    }catch(error){
      console.log('Error fetching air quality data:', error.message);
      throw error;}
  }
}
module.exports=AirService;