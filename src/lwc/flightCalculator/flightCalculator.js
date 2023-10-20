import {LightningElement, track} from 'lwc';
import bookFlight from "@salesforce/apex/FlightHandler.bookFlight";
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {NavigationMixin} from "lightning/navigation";

export default class FlightCalculator extends NavigationMixin(LightningElement) {

    /**
     * Represents that state of Spinner
     * @type {boolean}
     */
    isLoading = false;
    firstName;
    lastName;
    passportNumber;
    departureAirport;
    arrivalAirport;
    flightDate;
    errorText;
    @track formData = {};
    currentDate;
    connectedCallback() {
        let currentDate = new Date();
        this.currentDate = `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${currentDate.getDate()}`;
    };

    /**
     * Handles the First Name Input event
     */
    handleFirstName(event) {
        this.firstName = event.target.value;
    }

    /**
     * Handles the Last Name Input event
     */
    handleLastName(event) {
        this.lastName = event.target.value;
    }

    /**
     * Handles the Passport Number Input event
     */
    handlePassport(event) {
        this.passportNumber = event.target.value;
    }

    /**
     * Handles the Date Input event
     */
    handleDate(event) {
        this.flightDate = event.target.value;
    }

    /**
     * Handles the Departure Airport Lookup Input event
     */
    handleDepartureAirport(event) {
        this.departureAirport = event.target.value;
    }

    /**
     * Handles the Arrival Airport Lookup Input event
     */
    handleArrivalAirport(event) {
        this.arrivalAirport = event.target.value;
    }

    /**
     * Handles the Button Click event and send data from the from to the Apex class
     */
    handleBook() {
        if (!this.arrivalAirport || !this.departureAirport || !this.firstName || !this.lastName ||
            !this.passportNumber || !this.flightDate) {
            this.checkValidInput();
        } else if (this.arrivalAirport === this.departureAirport) {
            this.errorText = 'Your arrival airport must not be the same as your departure airport.';
            this.showToastMessage('Error', this.errorText, 'error');
        } else if (this.passportNumber.length < 5) {
            this.checkValidInput();
        } else if (Date.parse(this.flightDate) < Date.parse(this.currentDate)) {
            this.checkValidInput();
        } else {
            this.isLoading = true;

            this.formData = {
                arrivalAirport: this.arrivalAirport,
                departureAirport: this.departureAirport,
                firstName: this.firstName,
                lastName: this.lastName,
                passportNumber: this.passportNumber,
                flightDate: this.flightDate
            };

            bookFlight({jsonObject: this.formData})
                .then(flight => {
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: flight.Id,
                            objectApiName: 'Flight__c',
                            actionName: 'view'
                        },
                    });
                })
                .catch(error => {
                    this.showToastMessage('Error', error.message, 'error');
                })
                .finally(() => {
                    this.isLoading = false;
                })
        }
    }

    /**
     * The method for validation inputs
     */
    checkValidInput() {
        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),
            ...this.template.querySelectorAll('lightning-input-field'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
    }


    /**
     * The method for showing toast message
     *
     * @param title for toast message error or success
     * @param message with success information or error additional information
     * @param variant for toast message success or error
     */
    showToastMessage(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}