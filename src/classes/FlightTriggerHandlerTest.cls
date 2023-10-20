/**
 * Unit Test class for Flight Trigger Handler
 *
 * Revision		Date			Author				Comment
 * 1.0			08.12.2022		Michael Pugach	    Initial Version
 */
@IsTest
private class FlightTriggerHandlerTest {

    private static final Integer NUMBER_OF_RECORD = 200;

    /**
	 * Test Setup Method to create test data such as Airports and Flights
	 */
    @TestSetup
    static void setup() {
        List<Airport__c> airports = new List<Airport__c>();

        for (Integer i = 0; i < NUMBER_OF_RECORD; i++) {
            airports.add(new Airport__c(
                    Name = 'Airport ' + i,
                    Country__c = 'Country ' + i,
                    City__c = 'City ' + i,
                    Location__Latitude__s = Math.random() * 180 - 90,
                    Location__Longitude__s = Math.random() * 360 - 180,
                    IATA_Code__c = 'ATX'
            ));
        }

        insert airports;

        List<Flight__c> flights = new List<Flight__c>();

        for (Integer i = 0; i < NUMBER_OF_RECORD / 2; i++) {
            flights.add(new Flight__c(
                    Arrival_Airport__c = airports[i].Id,
                    Departure_Airport__c = airports[i + 1].Id,
                    Client_First_Name__c = 'First Name ' + i,
                    Client_Last_Name__c = 'Last Name ' + i,
                    Client_Passport_Number__c = 'AJ12303B'
            ));
        }

        insert flights;
    }

    /**
	 * Test of successful calculation of Flight Distance during insert and update
	 */
    @IsTest
    static void calculateFlightDistanceTest() {
        List<Flight__c> flights = [
                SELECT Arrival_Airport__r.Location__Longitude__s, Arrival_Airport__r.Location__Latitude__s,
                       Departure_Airport__r.Location__Latitude__s, Departure_Airport__r.Location__Longitude__s,
                       Distance__c
                FROM Flight__c
        ];

        for (Flight__c flight : flights) {
            Decimal distance = FlightHandler.calculateDistance(
                    flight.Arrival_Airport__r.Location__Latitude__s,
                    flight.Arrival_Airport__r.Location__Longitude__s,
                    flight.Departure_Airport__r.Location__Latitude__s,
                    flight.Departure_Airport__r.Location__Longitude__s
            );
            System.assertEquals(flight.Distance__c, distance / 1000);
        }

        List<Airport__c> airports = [
                SELECT Id
                FROM Airport__c
        ];

        for (Integer i = 0; i < flights.size(); i++) {
            flights[i].Arrival_Airport__c = airports[i + 1].Id;
            flights[i].Departure_Airport__c = airports[i].Id;
        }

        update flights;

        for (Flight__c flight : flights) {
            Decimal distance = FlightHandler.calculateDistance(
                    flight.Arrival_Airport__r.Location__Latitude__s,
                    flight.Arrival_Airport__r.Location__Longitude__s,
                    flight.Departure_Airport__r.Location__Latitude__s,
                    flight.Departure_Airport__r.Location__Longitude__s
            );
            System.assertEquals(flight.Distance__c, distance / 1000);
        }
    }
}