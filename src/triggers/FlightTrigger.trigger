/**
 * Flight Trigger that calls the execute method in Handler class
 *
 * Revision		Date			Author				Comment
 * 1.0			08.12.2022		Michael Pugach	    Initial Version
 */
trigger FlightTrigger on Flight__c (before insert, before update, before delete, after insert, after update,
                                    after delete, after undelete) {
    FlightTriggerHandler.execute();
}