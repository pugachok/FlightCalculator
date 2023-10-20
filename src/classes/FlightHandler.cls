/**
 * Flight Handler contains all auxiliary methods to work with Flights
 *
 * Tested by
 * FlightHandlerTest
 *
 * Revision		Date			Author				Comment
 * 1.0			08.12.2022		Michael Pugach	    Initial Version
 */
public class FlightHandler {

    /**
	 * Calculate the distance between two points
	 *
	 * @param latitude1 Point 1 Latitude
	 * @param longitude1 Point 1 Longitude
	 * @param latitude2 Point 2 Latitude
	 * @param longitude2 Point 2 Longitude
	 *
	 * @return The distance between points in meters
	 */
    public static Decimal calculateDistance(Decimal latitude1, Decimal longitude1,
                                            Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; // in meters
        // Transform coordinates from degrees to radians
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;

        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;

        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
                    Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
                    Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);

        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in metres

        return distance;
    }

    /**
     * The method processes the data from the form and creates the Flight record
     *
     * @param jsonObject Data from the form
     *
     * @return The created Flight record
     */
    @AuraEnabled
    public static Flight__c bookFlight(Object jsonObject) {
        try {
            FlightWrapper flightWrapper = new FlightWrapper();
            flightWrapper = (FlightWrapper) JSON.deserializeStrict(JSON.serialize(jsonObject), FlightWrapper.class);

            Flight__c flight = new Flight__c(
                    Arrival_Airport__c = flightWrapper.arrivalAirport,
                    Departure_Airport__c = flightWrapper.departureAirport,
                    Client_First_Name__c = flightWrapper.firstName,
                    Client_Last_Name__c = flightWrapper.lastName,
                    Client_Passport_Number__c = flightWrapper.passportNumber,
                    Flight_Date__c = Date.valueOf(flightWrapper.flightDate)
            );

            insert flight;

            return flight;
        } catch (Exception e) {
            insert new Error__c(
                    Message__c = e.getMessage(),
                    Stack_Trace__c = e.getStackTraceString()
            );

            return null;
        }
    }

    /**
     * The wrapper class to store data from the Flight Booking form
     */
    public class FlightWrapper {
        @AuraEnabled
        public String arrivalAirport;
        @AuraEnabled
        public String departureAirport;
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public String lastName;
        @AuraEnabled
        public String passportNumber;
        @AuraEnabled
        public String flightDate;
    }
}