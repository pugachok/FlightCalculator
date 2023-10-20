/**
 * Flight Trigger Handler contains all the methods required to process new, updated and deleted Flights
 *
 * Tested By
 * FlightTriggerHandlerTest
 *
 * Revision		Date			Author				Comment
 * 1.0			08.12.2022		Michael Pugach	    Initial Version
 */
public class FlightTriggerHandler {

    /**
	 * The common method to be executed only from trigger and call the handler methods
	 */
    public static void execute() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                calculateFlightDistance();
            } else if (Trigger.isUpdate) {
                calculateFlightDistance();
            }
        }
    }

    /**
	 * Calculates the distance between Departure and Arrival Airports on new Flights and when the Airport is changed
	 */
    private static void calculateFlightDistance() {
        List<Flight__c> newList = Trigger.new;
        Map<Id, Flight__c> oldMap = (Map<Id, Flight__c>) Trigger.oldMap;

        Set<Id> airportIds = new Set<Id>();

        if (Trigger.isInsert) {
            for (Flight__c flight : newList) {
                airportIds.add(flight.Departure_Airport__c);
                airportIds.add(flight.Arrival_Airport__c);
            }
        } else {
            for (Flight__c flight : newList) {
                if (flight.Departure_Airport__c != oldMap.get(flight.Id).Departure_Airport__c ||
                    flight.Arrival_Airport__c != oldMap.get(flight.Id).Arrival_Airport__c) {
                    airportIds.add(flight.Departure_Airport__c);
                    airportIds.add(flight.Arrival_Airport__c);
                }
            }
        }

        Map<Id, Airport__c> airportMap = new Map<Id, Airport__c>([
                SELECT Location__Latitude__s, Location__Longitude__s
                FROM Airport__c
                WHERE Id IN :airportIds
        ]);

        for (Flight__c flight : newList) {
            flight.Distance__c = FlightHandler.calculateDistance(
                    airportMap.get(flight.Departure_Airport__c).Location__Latitude__s,
                    airportMap.get(flight.Departure_Airport__c).Location__Longitude__s,
                    airportMap.get(flight.Arrival_Airport__c).Location__Latitude__s,
                    airportMap.get(flight.Arrival_Airport__c).Location__Longitude__s
            ) / 1000;
        }
    }
}