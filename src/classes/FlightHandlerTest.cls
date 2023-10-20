/**
 * Unit Test class for Flight Handler
 *
 * Revision		Date			Author				Comment
 * 1.0			08.12.2022		Michael Pugach	    Initial Version
 */
@IsTest
private with sharing class FlightHandlerTest {

    /**
	 * Test method for distance calculation
	 */
    @IsTest
    static void calculateDistanceTest() {
        Decimal point1Latitude = 38.9445;
        Decimal point1Longitude = -77.455803;
        Decimal point2Latitude = 33.942501;
        Decimal point2Longitude = -118.407997;

        Decimal distance = FlightHandler.calculateDistance(point1Latitude, point1Longitude, point2Latitude, point2Longitude);

        System.assertEquals(3674030.16423781461568000, distance);
    }

    /**
	 * Positive test method for creating Flight record base on data from the form
	 */
    @IsTest
    static void bookingFlightPositiveTest() {
        Airport__c arrivalAirport = new Airport__c(
                Name = 'Los Angeles International Airport',
                Country__c = 'US',
                City__c = 'Los Angeles',
                Location__Latitude__s = 33.942501,
                Location__Longitude__s = -118.407997,
                IATA_Code__c = 'AEH'
        );
        insert arrivalAirport;

        Airport__c departureAirport = new Airport__c(
                Name = 'Washington Dulles International Airport',
                Country__c = 'US',
                City__c = 'Washington',
                Location__Latitude__s = 38.9445,
                Location__Longitude__s = -77.455803,
                IATA_Code__c = 'PLN'
        );
        insert departureAirport;

        String jsonString = '{"arrivalAirport":"' + arrivalAirport.Id + '", "departureAirport":"' + departureAirport.Id +
                            '", "firstName":"Michael", "flightDate":"2022-12-08", "lastName":"Pugach", "passportNumber":"TestNumber"}';

        Flight__c flight = FlightHandler.bookFlight(JSON.deserializeUntyped(jsonString));

        System.assertEquals(arrivalAirport.Id, flight.Arrival_Airport__c, 'Arrival airport must be a same');
        System.assertEquals(departureAirport.Id, flight.Departure_Airport__c, 'Departure airport must be a same');
    }

    /**
	 * Negative test method for creating Flight record base on data from the form
	 */
    @IsTest
    static void bookingFlightNegativeTest() {
        Object jsonString = '';

        FlightHandler.bookFlight(jsonString);

        Error__c error = [
                SELECT Message__c
                FROM Error__c
                LIMIT 1
        ];

        System.assertEquals('Malformed JSON: Expected \'{\' at the beginning of object', error.Message__c);
    }
}